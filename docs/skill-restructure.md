# コミット系スキル再構成 引き継ぎドキュメント

本ドキュメントは設計議論の確定成果物であり、**実装は未着手**。
実装セッションは「実装手順」の順に作業を進めること。手順は 1 ステップ = 1 コミットで独立に成立するよう並べてある。
実装完了後、本ドキュメントは削除してよい（設計ルールを恒久ドキュメント化したい場合は別途移す）。

## 背景と動機

現行の `claude/skills/` のコミット系スキルには、呼び出し元に依存した記述が残っている。

* atomic-commit に「`rework-commit` から呼び出された場合」の例外ブロックがある（atomic-commit/SKILL.md:30-32）
* rework-commit は委譲時に「例外規定がある旨」をフラグとして伝える必要がある（rework-commit/SKILL.md:85）
* rebase --exec の起点が「作業開始時の HEAD（呼び出し元から指定されている場合はそのベースコミット）」と呼び出し元で分岐する（atomic-commit/SKILL.md:80）

原因は、スキルの契約が「呼び出し元が誰か」で書かれていること。本再構成では全スキルを**呼び出し時点のリポジトリ状態だけ**で定義し、呼び出し元依存の記述をゼロにする。合わせて検証系を check-* スキルとして分離し、権限を層で分ける。

## 設計ルール

1. スキルは目的で割る。手段（toolchain）で割らない。ディスパッチは、それで挙動が変わるスキルの内側に置く
2. 意図はスキル、共有知識はリファレンス、専有知識は本文、分岐は前提条件、権限は permissions
3. 各スキルは呼び出し時点の状態だけを見る。呼び出し元を知らない。本文に「〜から呼ばれた場合」を書かない
4. オーケストレーターは自前作業を持たない。プリミティブの順番と最終確認だけを書く
5. 変更なし＝チェック層、ローカル変更＝プリミティブ層、リモート変更（push・PR・merge）＝オーケストレーター層。上位の権限を下位に持ち込まない
6. スキル名は名前だけで挙動が推測できること。基本形は「動詞-目的語」

補足: frontmatter の description に書く「Do NOT use（use X instead）」はトリガー選択のガイドであり、実行時の例外規定ではない。これは残してよい。

## 最終構成

```
オーケストレーター層 ── 目的ごと。薄い（順番と最終確認だけ）。リモート操作はここだけ
│
├ rework-commit     「コミット整理して」   = reset-commit → atomic-commit → diff で同一性確認
│                                           （モデル起動可。ローカル専任なので安全）
├ create-pr         「PR 作って」          = check-* → ブランチ → atomic-commit → push → PR 作成
├ update-pr ※      「PR 更新して」        = check-* → atomic-commit → push → body 同期
│                                           履歴再編時: reset-commit → atomic-commit → force-push with lease
└ merge-pr ※       「マージまで見といて」 = CI 確認 → base 追従 → merge
                                            （PR 系 3 つは disable-model-invocation: true）

プリミティブ層 ── ローカルの状態を変える。push しない。呼び出し元を知らない
│
├ atomic-commit     worktree の未コミット変更を atomic なコミットに積む
│                   制約は一文:「呼び出し時点の HEAD より前に触れない」
└ reset-commit      既存コミットをバックアップしてから worktree へ戻す
                    （backup は untracked 含む全内容。dirty でも可。push 済みが対象なら確認）

チェック層 ── 検証する。リポジトリを変更しない（fmt は --check）。広範コマンドの置き場
│
├ check-build       ビルドが通るか
├ check-lint        静的検査が通るか（fmt --check 含む）
└ check-test        テストが通るか
                    （toolchain 検出は各スキル内部の 1 行。複数 toolchain は並列 subagent で実行し、
                      ログを subagent に吸収させて要約だけ返す）

リファレンス ── 知識。スキルではない
│
├ claude/references/toolchains.md   toolchain × 種類の行列（検出ファイル、コマンド、flags）
│                                   check-* が読む。atomic-commit の rebase --exec も直接読む
└ claude/references/remote.md ※    remote-default-ref 確定・fork 判定

消費者 ── redundant-comment-sweep はコミット工程に atomic-commit、検証に check-* を使う ※

※ = 将来（本 PR のスコープ外。手順 7 参照）
```

### ディスパッチ＝前提条件

分岐表はどこにも書かない。各スキルの前提条件が選択規則そのものになる。

| スキル | 前提条件 | 満たさないとき |
|---|---|---|
| atomic-commit | worktree に未コミット変更がある | 変更なしと報告して終了。整理対象がコミット済みなら rework-commit を案内 |
| reset-commit | ベース..HEAD にコミットがある | 何もせず終了。push 済みを含むなら「後で force-push が必要になる」旨を確認してから |
| create-pr | 現ブランチに open PR が無い | update-pr へ（update-pr 実装までは現行 5-2 の「push のみ」挙動を維持） |
| update-pr ※ | 現ブランチに open PR が有る | create-pr へ |

スキル間の受け渡しは reset-commit の完了報告（バックアップ名・戻したコミット一覧・確認方法）だけ。
これはプロトコルではなくただの作業報告であり、atomic-commit は受け取りを前提にしない。

### 権限のグラデーション

| 層 | できること | 実現手段 |
|---|---|---|
| チェック層 | 実行するが何も変更しない | check-* の不変条件。コマンド群は settings.yaml で allow 済み |
| プリミティブ層 | ローカルの git 変更のみ | allowed-tools は git の狭いサブコマンド＋Read/Write/Skill |
| オーケストレーター層 | push・PR・merge | `git push -u` は create-pr / update-pr のみ、`gh pr merge` は merge-pr のみ |

* スキルの allowed-tools は檻ではなく通行証（そのスキルの間、確認なしで通すものを増やす事前許可）。封じ込めの実体は settings.yaml の permissions と、必要なら subagent の tools 制限
* `Bash(git:*)` `Bash(gh:*)` のような全部入り allowed-tools は廃止し、正規手順で使うサブコマンドだけを列挙する

## 実装手順（1 ステップ = 1 コミット）

### 1. reset-commit 新設

`claude/skills/reset-commit/SKILL.md` を作成する。内容は現行 rework-commit の手順 1〜3 の移植＋前提条件化。

* **移植**: 現状確認とベースコミット特定（rework-commit 手順 1）、`git commit-tree` によるスナップショットバックアップ（手順 2。untracked を含む全内容、`.gitignore` 済みは含まれない旨の注意ごと）、`git reset <ベースコミット>`（手順 3。mixed reset。`git rebase -i` 禁止の注意ごと）
* **バックアップ名**: `backup/reset-commit-<timestamp>` へ変更
* **新規追加（現行の実ギャップ修正）**: ベース..HEAD のコミットがリモートに存在する場合、「再編後の push には force-push が必要になる」旨をユーザーへ確認してから進む。force-push 自体はこのスキルの責務ではない
* **前提条件**: ベース..HEAD にコミットがある。無ければ何もせず終了。worktree が dirty でも可（バックアップに含め、reset 後に worktree で合流する）
* **制約**: push しない。共有ブランチ不可。バックアップ作成前に破壊的操作をしない
* **完了報告**: バックアップ名、ベースコミット、戻したコミット一覧（元の意図の記録として）、最終確認方法（`git diff <backup> HEAD` が空になるべきこと）
* **description**: 単独トリガーは限定的（「コミットを一旦バラして」等）。主に rework-commit / update-pr の部品である旨を書く

### 2. atomic-commit 書き直し

* 「例外: `rework-commit` から呼び出された場合」ブロックを削除する
* 制約を entry-HEAD 基準の一文にする: 「**呼び出し時点の HEAD より前には一切触れない。その上に新規コミットのみを作る**」。reset 直後でも単独利用でも同じ文が無修正で成立する
* リダイレクトを状態条件にする: 「整理対象の変更が working tree に無い（既にコミット済みの）場合は rework-commit を案内して終了」
* rebase --exec の起点を「作業開始時（呼び出し時点）の HEAD」のみにする。括弧書きの呼び出し元分岐を削除
* `references/splitting.md` を本文へ統合し、ファイルを削除する。統合時に create-pr の Conventional Commits type 表も本文のメッセージ規約へ吸収する
* 検証を再構成する:
  * コミット単位検証の方法 A（stash 退避）/ 方法 B（rebase --exec）は維持。実行コマンドは `claude/references/toolchains.md` を読んで組む（手順 4 の後に参照先を差し替え。手順 2 の時点では現行記述のままでよい）
  * 最終状態の全体検証は check-build / check-lint / check-test の呼び出しにする（同上）
  * 「呼び出し元が変更全体の検証済みを明示した場合、コミット単位検証を省略できる」パラメータは維持（create-pr / redundant-comment-sweep が使用中）
* 前提条件: worktree に未コミット変更がある。無ければ報告して終了
* allowed-tools を追加する。方針: git の狭いサブコマンド（status / diff / log / add / commit / stash / apply / reset / branch / rev-parse / write-tree など実手順で使うもの）＋ Read / Write（patch ファイル用）＋ Skill。push 系・gh 系は載せない

### 3. rework-commit 薄化

本文を「順番と最終確認だけ」にする。

1. reset-commit を呼ぶ
2. atomic-commit を呼ぶ
3. `git diff <バックアップ> <HEAD>` で最終ツリーの同一性を機械的に確認する
4. 完了報告（バックアップ名、再編前後のコミット数、同一性確認の結果）

* 現行の手順 1〜3（ベース特定・バックアップ・reset）と手順 4 の引き継ぎ 5 項目リストを削除する（reset-commit へ移動済み。atomic-commit への申し送りは不要になった）
* description のトリガーフレーズ（「コミット整理して」「履歴を綺麗にして」等）は維持

### 4. toolchains.md 作成＋check-build / check-lint / check-test 新設

`claude/references/toolchains.md` を作成し、create-pr 手順 2 の検出表を移植・拡張する。

| 検出ファイル | toolchain | build | lint | test |
|---|---|---|---|---|
| Cargo.toml | cargo | `cargo build` | `cargo clippy --all-targets --all-features` / `cargo fmt --all -- --check` | `cargo test` |
| pnpm-lock.yaml | pnpm | `pnpm build`（script がある場合） | `pnpm lint` / `pnpm typecheck`（同左） | `pnpm test`（同左） |
| package-lock.json | npm | `npm run build`（script がある場合） | `npm run lint` / `npm run typecheck`（同左） | `npm test`（同左） |
| go.mod | go | `go build ./...` | `go vet ./...` / `gofmt -l .` | `go test ./...` |
| Makefile / Taskfile.yml | make / task | 対応するターゲットがあればそれを使う | 同左 | 同左 |

* いずれにも該当しない場合のフォールバック（CI 定義 `.github/workflows/` をローカルで再現できる範囲で実行する）も現行 create-pr から移植する
* `claude/Makefile` は `claude/references/` が存在すれば `~/.claude/references` へ symlink する実装済み（claude/Makefile:45-48）。ディレクトリを作るだけで配備される

`claude/skills/check-build/SKILL.md` / `check-lint` / `check-test` を作成する。各 15 行程度。

* 手順: toolchains.md を読む → 検出ファイルで toolchain を特定（複数該当は全部） → toolchain ごとに自分の列のコマンドを実行（複数 toolchain は並列 subagent に委譲し、ログを吸収させて要約だけ受け取る） → 成否と失敗時のログ要点を報告
* **不変条件: リポジトリを変更しない**。fmt は `--check`。自動修正はしない
* allowed-tools 方針: 自分の列で使うコマンド（cargo / pnpm / npm / go / gofmt / make / task）＋ Read / Glob / Grep ＋ subagent 起動。git 変更系・push 系は載せない

### 5. create-pr 縮小

* 手順 2（ビルド検証）を「check-build / check-lint / check-test を呼ぶ。失敗したら中断」に置換し、検出表を削除する
* 手順 4 の type 表を削除する（atomic-commit 本文へ吸収済み）。PR タイトルの type は「作成されたコミットの主要な type に合わせる」の 1 行にする
* atomic-commit の検証参照差し替え（手順 2 の残作業）があればここで実施
* allowed-tools を絞り込む: `Bash(git:*)` `Bash(gh:*)` と cargo / npm / go / make / task 系（check-* へ移管）を廃止し、正規手順のサブコマンドのみ列挙する。目安: git の status / diff / log / branch / switch / fetch / rev-parse / remote / `push -u` 系、gh の `repo view` / `pr view` / `pr create`、Read / Glob / Grep / Skill。Write / Edit は委譲後は不要のはずなので、残す場合は理由を確認すること
* 前提条件「open PR が無い」を明記。open PR がある場合の挙動は現行 5-2（push のみ）を維持し、update-pr 実装時に委譲へ切り替える

### 6. settings.yaml へ deny 追加

`claude/settings.yaml` の permissions に deny キーを新設する。

```yaml
permissions:
  deny:
  - "Bash(git push --force:*)"
  - "Bash(git push -f:*)"
```

push / merge 系を allow へ入れない現状は維持（確認に落とすため）。

### 7. 将来（本 PR のスコープ外）

* update-pr / merge-pr の新設（構成は「最終構成」の通り）
* `claude/references/remote.md` の抽出（create-pr 手順 1 の remote-default-ref 確定・fork 判定ロジック。update-pr / merge-pr と共有するため）
* redundant-comment-sweep の検証手順（ラウンド内の formatter / lint / build / test）を check-* 呼び出しへ置換
* 各スキルへの allowed-tools 横展開の精査

## 受け入れ基準

* 全 SKILL.md 本文に「〜から呼ばれた場合」という呼び出し元分岐が存在しない
* rework-commit 経由でも単独でも、atomic-commit の手順記述が同一（例外・読み替え指示なし）
* rework-commit に自前の git 操作手順がない（同一性確認の diff を除く）
* `splitting.md` が存在しない（本文統合済み）
* check-* にリポジトリを変更する記述がない（fmt は `--check`）
* allowed-tools に `Bash(git:*)` / `Bash(gh:*)` が残っていない
* reset-commit が push 済みコミットの reset 前にユーザー確認を挟む
* 各ステップが独立したコミットになっている

## 却下済みの代替案（再検討しないこと）

* **analyze-commit / 調査系スキル**（コミット状態・リモート状態・ワークツリー状態を調べるスキル）: 封じ込める手続き知識がない（`git status` は 1 コマンド）。スキルには型付き戻り値がなく、呼んでも会話に文が増えるだけ。「調べる」は意図にならずトリガーが成立しない。調査は各スキルの手順 1 行で足りる
* **build-cargo / test-pnpm など toolchain 別スキル**: toolchain はリポジトリ依存（行列の「行」）なので、スキルに割ると「どれを呼ぶか」の判断が全呼び出し元へ漏れる。列（build / lint / test）で割り、行はリファレンスで持つ
* **スキル分割をセキュリティ境界にする案**: スキルは同じ会話に手順書が差し込まれるだけで、権限境界にならない。allowed-tools は檻ではなく通行証。封じ込めは settings.yaml の permissions と subagent の tools 制限で行う
* **verify / run-checks という単一検証スキル**: 名前から挙動が読めない（設計ルール 6 違反）。check-build / check-lint / check-test へ分割
* **soft-reset-commit という名前**: 実装は `git reset`（mixed）であり soft ではない。reset-commit が正確
* **オーケストレーター廃止（状態駆動の自動連鎖のみ）案**: 「意図 1 つにつきスキル 1 つ」の対応表の分かりやすさと、end-to-end 検証（バックアップと最終 HEAD の同一性）のオーナーを残すため、薄いオーケストレーターを維持する

## 対象外

* `claude/skills/japanese-tech-writing/` — 無関係
* `claude/skills/redundant-comment-sweep/` — 手順 7 の check-* 置換まで変更しない
* claude/ 以外のディレクトリ全て
