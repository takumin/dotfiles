# コミット系スキル仕様書（引き継ぎ）

`claude/skills/` 配下のコミット系スキル一式の仕様書。
**この文書を読んだエージェントが、この文書だけを根拠に全体を実装する前提で書かれている。**
既存スキルの内容を読む必要はない。既存ファイルは §7 の作成手順に「置き換え・削除・部分修正の対象」としてのみ登場する。

* 固定点は「§1 要求事項」。§2 以降の設計は提案であり、要求を満たす限りゼロベースで変更してよい。検討の経緯は付録に残してある
* 提案のまま実装する場合は §7 の順に進める。1 ステップ = 1 コミット

## 1. 要求事項

* **R1** — スキル本文が挙動の分岐条件にしてよいのは、明示的に渡された入力（呼び出し時の指定と、実行中にユーザーへ確認して得た回答）と、スキル自身が観測できる状態（呼び出し時点の状態と、実行中に得た結果）だけ。呼び出し元・呼び出し経路（ユーザー直接か他スキル経由かを含む）を分岐条件にしない。「〜から呼ばれた場合」のような分岐・例外規定・読み替え指示はこれに当たる
* **R2** — 履歴を戻す・書き換える操作は、事前バックアップなしに行わない。push 済みコミットを戻す場合は、後で force-push が必要になる旨をユーザーへ確認してから行う
* **R3** — 検証（build / format / lint / test）コマンドの知識は、正となる記述箇所が一意であること。同じコマンドを複数のスキル本文に重複記述しないこと
* **R4** — 検証はリポジトリを変更しない（formatter は check モード）
* **R5** — リモートを変更する操作（push・PR 作成・merge）は、その操作自体を目的とするスキルだけが行うこと。コミット作成・履歴再編・検証を担うスキルは push・merge を行わないこと
* **R6** — allowed-tools には正規手順で使うコマンドだけを載せる。`Bash(git:*)` `Bash(gh:*)` のような全部入りを書かない
* **R7** — スキル名は名前だけで挙動が推測できること
* **R8** — コミット再編の前後で最終ツリー内容が同一であることを、機械的に（diff で）確認できる
* **R9** — スキルはディレクトリ単体で配布できること。スキルディレクトリの外のファイルに依存しない

## 2. 全体像

```
オーケストレーター層 ── 目的ごと。薄い（順番と最終確認だけ）。リモート操作はここだけ
│
├ rework-commit     「コミット整理して」   = reset-commit → atomic-commit → diff で同一性確認
├ create-pr         「PR 作って」          = check-* → ブランチ → atomic-commit → push → PR 作成
├ update-pr         「PR 更新して」        = check-* → atomic-commit → push → body 同期
│                                           履歴再編時: rework-commit → force-push with lease
└ merge-pr          「マージまで見といて」 = 状態確認 → base 追従 → CI 確認 → merge

プリミティブ層 ── ローカルの状態を変える。push しない。呼び出し元を知らない
│
├ atomic-commit     worktree の未コミット変更を atomic なコミットに積む
└ reset-commit      既存コミットをバックアップしてから worktree へ戻す

チェック層 ── 検証する。リポジトリを変更しない。広範なコマンドの置き場
│
├ check-build       ビルドが通るか
├ check-format      フォーマットが適用済みか（formatter の check モード）
├ check-lint        静的検査が通るか
├ check-test        テストが通るか
└ check-review      変更内容に問題がないか（コードレビュー。toolchain 非依存）
```

作成対象はこの 11 スキル。加えて redundant-comment-sweep の部分修正と settings.yaml の編集（§7）。

### ディスパッチ＝前提条件

分岐表はどこにも書かない。各スキルが自分の前提条件を持ち、その集合が選択規則になる。

| スキル | 前提条件 | 満たさないとき |
|---|---|---|
| atomic-commit | worktree に未コミット変更がある | 変更なしと報告して終了。整理対象がコミット済みなら rework-commit を案内 |
| reset-commit | ベース..HEAD にコミットがある | 何もせず終了。push 済みを含むなら R2 の確認を挟んでから |
| create-pr | 現ブランチに open PR が無い | update-pr へ委譲 |
| update-pr | 現ブランチに open PR が有る | create-pr へ委譲 |
| merge-pr | 対象 PR が open である | その旨を報告して終了 |

スキル間の受け渡しは reset-commit の完了報告（バックアップ名・戻したコミット一覧・確認方法）だけ。
これはプロトコルではなくただの作業報告であり、後続スキルは受け取りを前提にしない（R1）。

### 権限のグラデーション

| 層 | できること | 実現手段 |
|---|---|---|
| チェック層 | 実行するが何も変更しない | check-* の不変条件（R4） |
| プリミティブ層 | ローカルの git 変更のみ | allowed-tools は git の狭いサブコマンド＋Read/Write/Skill |
| オーケストレーター層 | push・PR・merge | `git push -u` は create-pr / update-pr、`--force-with-lease` は update-pr のみ、`gh pr merge` は merge-pr のみ |

### 設計原則

1. スキルは目的で割る。手段（toolchain）で割らない。ディスパッチは、それで挙動が変わるスキルの内側に置く
2. 意図はスキル、専有知識は本文、分岐は前提条件、権限は permissions
3. 各スキルは呼び出し時点の状態だけを見る。呼び出し元を知らない
4. オーケストレーターは自前作業を持たない。下位スキルの順番と最終確認だけを書く
5. 変更なし＝チェック層、ローカル変更＝プリミティブ層、リモート変更＝オーケストレーター層
6. スキル名は名前だけで挙動が推測できること。基本形は「動詞-目的語」

### 記述規約（全スキル共通）

* SKILL.md 本文は日本語。frontmatter の description は英語で、日本語・英語のトリガーフレーズ例を含める
* description の「Do NOT use（use X instead）」はトリガー選択のガイドとして書いてよい（実行時の例外規定ではないので R1 に反しない）
* コミットメッセージと PR body は英語（リポジトリ既存規約）
* 対話コマンド（`git add -p`、`git rebase -i`）は使わない。非対話環境で失敗するため
* allowed-tools は「そのスキルの手順に登場するコマンド・ツールをすべて列挙し、それ以外を載せない」が規範（R6）。各スキル仕様に書いた一覧は、この規範を手順に適用した結果である
* SKILL.md は次の形式で書く（allowed-tools 以下の 3 キーは任意）

```markdown
---
name: <スキル名。小文字とハイフン>
description: <英語。用途、日英のトリガーフレーズ例、必要なら Do NOT use（use X instead）>
allowed-tools: <カンマ区切り。例: Bash(git status:*), Read, Skill>
argument-hint: <引数のヒント。引数を取るスキルのみ>
disable-model-invocation: true   # スラッシュコマンド専用にする場合のみ
---

# <スキル名>

<本文。日本語>
```

## 3. プリミティブ仕様

### 3.1 atomic-commit

worktree の未コミット変更を、論理的かつ atomic な単位のコミットに積むスキル。
レビュー・revert・bisect・cherry-pick を容易にすることが目的。

**frontmatter**

* description: 未コミット変更のコミット化に使う旨＋トリガー例（「いい感じにコミットして」「コミットして」「commit this properly」等）＋他スキルのコミット工程としても使われる旨＋「既存コミットの再編には使わない（rework-commit へ）」
* allowed-tools: git の status / diff / log / add / commit / stash / apply / reset / restore / checkout（作成した自コミットの検証巡回用）/ rev-parse / branch（読み取り用途）＋ Read / Write（patch ファイル用）＋ Grep / Glob ＋ Skill（check-* 呼び出し用）。push 系・gh 系は載せない（R5・R6）

**前提条件**: worktree に未コミット変更（staged / unstaged / untracked）がある。無ければその旨を報告して終了。ユーザーの整理対象が既にコミット済み（worktree に無い）なら rework-commit を案内して終了。

**制約**

* **呼び出し時点の HEAD より前には一切触れない。その上に新規コミットのみを作る**（この一文だけで、単独利用でも reset 直後でも同じ意味で成立する — R1）
* push しない
* main / master / develop 等の共有ブランチ上なら、開始前にユーザーへ確認する
* 機能追加・バグ修正・追加リファクタリングをしない。コミット作成に不要なコード変更をしない
* 作業開始時と終了時で worktree のファイル内容を変えない

**手順 1 — 現状確認**: ブランチ名（共有ブランチでないこと）、`git status -uall`（ディレクトリ折り畳みで未追跡を見落とすため `-uall` 必須）、`git diff` と `git diff --cached`、`git log --oneline -10`（既存メッセージ規約の把握）、`git rev-parse HEAD`（呼び出し時点の HEAD の記録。制約と手順 4 方法 B の基準になる）、変更が実現した要求事項。

**手順 2 — 分析と計画**: 差分をファイル単位ではなく**変更意図単位**で分析し、コミット計画を提示する。

* 分類観点: 型・インターフェース・スキーマ等の基盤 / ドメインロジック / アプリケーションロジック / 外部統合 / 設定 / テスト / ドキュメント / 純リファクタリング / 自動生成物 / フォーマットのみ / 不要コード削除
* atomic の定義: 1 つの目的だけを持つ / 単体で意図を説明できる / 可能な限り単体でビルド・テストが通る / 後続コミットを前提にしなくても整合する / 独立して revert・cherry-pick できる / リファクタリングと振る舞い変更を分離する
* 計画の記載項目（コミットごと）: タイトル / 目的 / 含めるファイルまたは hunk / 含めない関連変更 / 依存する先行コミット / 実行する検証 / 単独 revert 可否
* 順序: 前提となる型・設定 → 内部実装 → 統合 → テスト → ドキュメント。ただし実際の依存関係を優先。テストは原則対象実装と同じコミット（既存挙動を固定する characterization test 等、明確な理由がある場合のみ分離可）
* 分割しない判断も明示する: 分割すると中間コミットがビルド不能 / 変更同士が強く結合 / 独立 revert が非現実的 / 分割で意図が読みにくくなる — の場合は 1 コミットにまとめる。逆にリファクタと機能変更、フォーマットとロジック、独立バグ修正同士、無関係な設定変更は分離する

**手順 3 — コミット作成**: 計画の順に stage → 確認 → commit を繰り返す。

* パスを明示して `git add <ファイル>`。`git add -A` / `git add .` は使わない
* 同一ファイルに複数の論理変更が混在する場合の hunk 分割: `git diff -- <ファイル>` を patch ファイルとしてリポジトリ外（一時ディレクトリ）へ保存 → stage する hunk だけ残して編集 → `git apply --cached <patch>` → `git diff --cached` で計画と一致確認。patch の編集は hunk 全体の残す/消すの単位で行い、hunk 内部の行を編集した場合は `git apply --cached --recount`。未追跡ファイルの hunk 分割は `git add -N <ファイル>` で追跡化してから
* stage 前チェック: `.env` / `*.pem` / `*.key` / `credentials.json` 等の機密ファイル、`node_modules/` `target/` `dist/` 等の成果物が含まれていたらコミットせず警告
* コミットメッセージ: リポジトリの既存規約に従う。無ければ Conventional Commits（`<type>[scope]: <description>`）。type の選択基準 — feat: 新機能 / fix: バグ修正 / docs: ドキュメントのみ / style: コードの意味に影響しない変更（空白・フォーマット等） / refactor: 機能追加でもバグ修正でもないコード変更 / perf: 性能改善 / test: テストの追加・修正 / build: ビルドシステム・外部依存の変更 / ci: CI 設定の変更 / chore: その他。description は英語 70 文字以内、body は「何を」でなく「なぜ」。HEREDOC で渡す。trailer はセッションのシステム指示があればそれに従う
* pre-commit hook がファイルを書き換えたら再 add してコミットし直す。`--no-verify` は使わない

**手順 4 — 検証**: 検証は常に check-build / check-format / check-lint / check-test の呼び出しで行う。このスキルは検証コマンドを知らない（R3）。worktree には後続コミット予定の変更が残っているため、以下のいずれかを使う。

* 方法 A（作成しながら）: コミット直後に `git stash push -u` で残りを退避 → check-* を呼ぶ → `git stash pop`。検証がファイルを生成・変更する場合は pop 前に戻す。壊れたコミットの上に積む前に問題へ気づける
* 方法 B（作成後に一括）: 全コミット作成後（worktree は clean）、作成したコミットを古い順に `git checkout <コミット>` で checkout し、それぞれで check-* を呼ぶ。終了時は成否にかかわらず必ず元のブランチへ戻る。履歴に触れないためハッシュは変わらない
* 省略条件: 呼び出し元（スキルまたはユーザー）が変更全体の検証を実行済みと明示した場合、コミット単位の検証を省略し最終状態の check-build / check-format / check-lint / check-test のみでよい。省略した事実は報告する
* あるコミット単体で検証が通らない場合: 境界を見直す / 依存変更を統合する / 単体検証できない理由を明示する — のいずれか。意図的にテストを失敗させるコミットは要求されない限り作らない

**手順 5 — 最終確認**: worktree が clean / 開始時とファイル内容が一致 / 順序が依存関係に沿う / 各コミットが単一目的 / メッセージが内容と一致。

**完了報告**: コミット一覧（`git log --oneline`）/ 各コミットの目的 / 各コミットで実行した検証 / 最終状態で実行した検証 / 実行しなかった検証と理由 / コミットしなかった変更と理由 / 残リスク。

### 3.2 reset-commit

ブランチの既存コミットを、バックアップを取ってから worktree へ戻す（uncommit する）スキル。
これ自体はコミットを作らない。主に rework-commit の部品。

**frontmatter**

* description: 既存コミットを worktree へ戻す旨＋単独トリガーは限定的（「コミットを一旦バラして」等）＋主に他スキルの部品である旨＋「コミットを積み直すのは atomic-commit」
* allowed-tools: git の status / log / diff / rev-parse / merge-base / branch / add / reset / write-tree / commit-tree ＋ Read / Grep / Glob。push 系・gh 系・`git commit` は載せない（バックアップは commit-tree で足りる）

**前提条件**: ベース..HEAD にコミットがある。無ければ何もせず終了。worktree が dirty でも可（バックアップに含め、reset 後に worktree で合流する）。

**制約**: push しない / 共有ブランチ不可 / バックアップ作成前に変更を失う可能性のある操作をしない（R2）。

**手順 1 — 現状確認とベース特定**: ブランチ名（共有ブランチでないこと）、ベースブランチまたは分岐元コミット、ベースとの差分、コミット履歴、staged / unstaged / untracked の有無。ベースコミットが不明確なら merge-base・ブランチ履歴・リモート追跡ブランチから合理的に特定し、以降すべての手順で同じベースを使う。

**手順 2 — push 済み確認（R2）**: 現在ブランチに upstream があり、ベース..HEAD のコミットがリモートに到達済み（例: `git merge-base --is-ancestor <コミット> @{u}`）なら、「reset 後の push には force-push が必要になる」旨をユーザーへ確認してから進む。force-push 自体はこのスキルの責務ではない。

**手順 3 — バックアップ**: バックアップは HEAD ではなく、**未コミット・未追跡を含む作業開始時点のファイル内容全体**を指す必要がある。

```bash
git add -A
git branch backup/reset-commit-<timestamp> \
  "$(git commit-tree "$(git write-tree)" -p HEAD -m 'snapshot before reset-commit')"
git reset
```

* `git commit-tree` はどのブランチにも接続されない独立コミットを作るため、現在のブランチに影響しない
* `git add -A` により未追跡ファイルも含まれる。`.gitignore` 済みは含まれないため、保護が必要な生成物があれば別途退避する
* 作成後 `git rev-parse backup/reset-commit-<timestamp>` で存在を確認する
* `<timestamp>` は `date +%Y%m%d-%H%M%S` で生成する

**手順 4 — reset**: バックアップの存在確認後、`git reset <ベースコミット>`（mixed）。HEAD はベースへ戻り、全変更が unstaged で worktree に残る。ベース以降に追加されたファイルは untracked になるため `git status -uall` で確認する。

**完了報告**: バックアップブランチ名 / ベースコミット / 戻したコミット一覧（元の変更意図の記録として）/ 作業完了後は `git diff <バックアップ> HEAD` が空になるべきこと。この報告はただの作業記録であり、後続スキルは受け取りを前提にしない（R1）。

## 4. チェック層仕様

チェック層に共通の不変条件（R4）: **リポジトリを変更しない。** 修正・自動整形をしない（formatter は check モード）。git の変更系コマンドを使わない。失敗・指摘の報告だけを返す。

### 4.1 check-build / check-format / check-lint / check-test（toolchain 駆動）

4 スキルは同型で、違いは実行するコマンドの種類だけ。各スキルは**検出表と自分の種類のコマンドを本文に持ち、スキルディレクトリ単体で完結する**（R9）。共有ファイルは作らない — 各種類のコマンドの消費者は対応するスキル 1 つだけなので専有知識であり（設計原則 2）、検出表（下表の左 2 列）の 4 重複は許容する。toolchain の追加はどのみち全種類のコマンド追記を伴うため、共有化しても編集の手間は減らない。

* 手順: 本文の検出表で toolchain を特定（複数該当なら全部） → toolchain ごとに自分の種類のコマンドを実行 → 成否と失敗時のログ要点を報告
* 複数 toolchain の場合は subagent に並列委譲し、ログを subagent に吸収させて要約だけ受け取る（コンテキスト汚染防止）
* 前提条件: 該当 toolchain が 1 つも検出できなければ「検証対象なし」と報告して終了（下記フォールバックを試した上で）
* フォールバック: どの行にも該当しない場合、CI 定義（`.github/workflows/`）を確認し、自分の種類に相当するチェックをローカルで再現できる範囲で実行する
* allowed-tools: 自分の種類の列に登場するコマンド＋ Read / Glob / Grep ＋ Task（subagent 起動）。git 変更系・push 系は載せない

**author 用の元データ**（各スキルの本文には検出列＋自分の列だけを書く。他の列は書かない）

| 検出ファイル | toolchain | check-build | check-format | check-lint | check-test |
|---|---|---|---|---|---|
| Cargo.toml | cargo | `cargo build` | `cargo fmt --all -- --check` | `cargo clippy --all-targets --all-features` | `cargo test` |
| pnpm-lock.yaml | pnpm | `pnpm build` † | `pnpm format:check` † | `pnpm lint` / `pnpm typecheck` † | `pnpm test` † |
| package-lock.json | npm | `npm run build` † | `npm run format:check` † | `npm run lint` / `npm run typecheck` † | `npm test` † |
| go.mod | go | `go build ./...` | `gofmt -l .` ‡ | `go vet ./...` | `go test ./...` |
| Makefile / Taskfile.yml | make / task | 対応するターゲットが定義されていればそれ | 同左 | 同左 | 同左 |

† JS 系は `package.json` の `scripts` に該当スクリプトが定義されている場合のみ実行する。
‡ `gofmt -l` は未整形でも終了コードが 0 のまま、未整形ファイル名を出力する。出力が空でないことを失敗として扱う。

* 拡張ルール: toolchain の追加は 4 スキルそれぞれへ検出行＋自分の種類のコマンドを 1 行ずつ追記する。検証の種類の追加はチェック層スキルの追加で行う
* description の要旨: check-build「ビルド（コンパイル）が通るかを検証する」/ check-format「フォーマットが適用済みかを検証する」/ check-lint「lint・type check が通るかを検証する」/ check-test「テストが通るかを検証する」

### 4.2 check-review（モデル駆動）

変更内容をコードレビューし、指摘の一覧を返すスキル。toolchain 非依存。

* **前提条件**: レビュー対象の差分がある。優先順: 呼び出し時に範囲の指定があればそれ → worktree の未コミット変更 → ベース（merge-base または remote-default-ref）..HEAD。いずれも無ければ「対象なし」と報告して終了
* **手順**: 対象差分を確定 → 差分が大きければファイル群で分割して subagent に並列委譲（差分の読み込みを subagent に吸収させる） → 指摘を集約・重複排除し、重要度をつけて報告
* **観点**（本文に書く専有知識）: 正しさ（バグ、エッジケース、エラー処理）/ セキュリティ（機密情報の混入、入力検証、権限）/ 設計（責務、依存方向、既存規約との整合）/ 可読性（命名、コメントの過不足）/ テスト（不足している観点）
* **報告形式**: 指摘ごとに重要度・対象（`file:line`）・内容・修正案の要旨。重要度は 3 段階 — **重大**（バグ・セキュリティ・データ破壊の可能性。マージすべきでない）/ **改善**（直すべきだが blocker ではない）/ **軽微**（好み・nit）
* 指摘のみで修正はしない（R4）。修正の実施は呼び出し元またはユーザーの判断
* allowed-tools: git の diff / log / show / status / rev-parse / merge-base（読み取り系）＋ Read / Grep / Glob ＋ Task（subagent 起動）。実行系・変更系のコマンドは載せない
* description の要旨: 変更内容のコードレビューに使う旨＋トリガー例（「レビューして」「review my changes」等）＋「機械的な検証は check-build / check-format / check-lint / check-test へ」

## 5. オーケストレーター仕様

### 5.1 rework-commit

現在のブランチの既存コミット履歴を、論理的で atomic な単位に再編するスキル。自前の git 操作は最終確認の diff だけ（設計原則 4）。

**frontmatter**

* description: 既存コミットの再編に使う旨＋トリガー例（「コミット整理して」「コミット分割して」「履歴を綺麗にして」「clean up git history」「make this PR reviewable」等）＋「未コミット変更のコミット化は atomic-commit」
* allowed-tools: Skill ＋ git の diff / log / rev-parse（読み取り系のみ）

**手順**

1. reset-commit を呼ぶ（前提条件を満たさなければそこで終了する。それがこのスキルの終了条件にもなる）
2. atomic-commit を呼ぶ
3. `git diff <バックアップブランチ> HEAD` で最終ツリーの同一性を機械的に確認する（R8）。差分があれば原因を調査し、解消してから完了とする
4. 完了報告: バックアップブランチ名 / 再編前後のコミット数 / 再編後のコミット一覧 / 同一性確認の結果

### 5.2 create-pr

ブランチを作成し、コミットし、PR を作成するスキル。

**frontmatter**

* description: PR 作成に使う旨（トリガー: PR 作って、submit changes 等）＋「既に open PR があるブランチの更新は update-pr」
* argument-hint: `[branch-name]`
* disable-model-invocation: true（スラッシュコマンド専用）
* allowed-tools: `Bash(git status:*)` `Bash(git diff:*)` `Bash(git log:*)` `Bash(git branch:*)` `Bash(git switch:*)` `Bash(git fetch:*)` `Bash(git rev-parse:*)` `Bash(git remote:*)` `Bash(git push -u:*)` `Bash(gh repo view:*)` `Bash(gh pr view:*)` `Bash(gh pr create:*)` ＋ Read / Glob / Grep / Skill。検証コマンドはチェック層へ、コミット作成は atomic-commit へ委譲するため、cargo / npm 等の実行系と Write / Edit は載せない（R6）

**手順 1 — 現状確認**（並列実行）: `git status -uall` / `git diff` と `git diff --cached` / `git log --oneline -10` / `git branch --show-current` / `gh repo view --json defaultBranchRef,nameWithOwner` / `git remote -v` / `gh pr view --json url,state`。コミットすべき変更が無ければ終了。

* 前提条件の確認: `gh pr view` で現ブランチに open な PR が見つかった場合は、update-pr へ委譲して終了する。PR が無い場合は `no pull requests found` を出力して非ゼロ終了するが、**それがこのスキルの正常系であり、エラーとして報告・中断しない**
* コミット範囲の起点 `<remote-default-ref>` をここで 1 つに確定する: fork 運用（origin が自分の fork、upstream が本家）なら `upstream/<default-branch>`、それ以外は `origin/<default-branch>`。**ローカルブランチ名（`main` 等）は使わない**（存在しなければ unknown revision で失敗し、存在しても古いと範囲がずれる）。`git rev-parse --verify` で解決を確認し、できなければ `git fetch <remote> <default-branch>` 後に再確認

**手順 2 — 検証**: check-build / check-format / check-lint / check-test / check-review を呼ぶ。**build / format / lint / test の失敗、または check-review の重大な指摘があれば、PR 作成を中断して報告する**（改善・軽微の指摘は報告のみで続行してよい）。

**手順 3 — ブランチ**: 判定は上から順に評価する。(1) 引数があればそのブランチ名（現在名と一致なら何もしない） / (2) 現在ブランチがデフォルトブランチ以外ならそのまま使う（デフォルトブランチは手順 1 の結果で判定。main / master 決め打ちにしない） / (3) それ以外は変更内容から `<type>/<short-description>` 形式で生成。作成は `git switch -c`。同名ブランチが既に在る場合は `git log --oneline <remote-default-ref>..<branch>` で独自コミットを確認し、無ければ switch、有れば過去作業の混入を避けるため別名を使うかユーザーへ確認。

**手順 4 — コミット**: atomic-commit を Skill として呼び、以下を伝える: `<remote-default-ref>`（範囲の起点）/ 手順 2 で変更全体の検証済みのためコミット単位検証は省略可 / push しないこと。完了後 `git log --oneline <remote-default-ref>..HEAD` で確認。

**手順 5 — push と PR 作成**: `git push -u origin HEAD` の後、PR を作成する。`.github/PULL_REQUEST_TEMPLATE.md`（大文字小文字両方）があればその構成で、無ければ Summary / Test plan 構成で body を書く。`--base` にはデフォルトブランチ名（ref ではなくブランチ名）を明示。fork 運用では `--repo <upstream の nameWithOwner>` と `--head <owner>:<branch>` を必ず指定（省略すると fork 側に PR が作られるか、対話プロンプトで非対話実行がハングする）。タイトルは英語 70 文字以内で、**作成されたコミットの主要な type に合わせた** Conventional Commits 形式。body は英語。

**手順 6 — 報告**: ブランチ名 / 作成コミット / 実行した検証と結果 / PR の URL。

### 5.3 update-pr

現在のブランチの open PR を、最新の変更で更新するスキル。

**frontmatter**

* description: PR の更新に使う旨（トリガー: 「PR 更新して」「レビュー対応を反映して」「update the PR」等）＋「open PR が無いブランチは create-pr」
* disable-model-invocation: true（スラッシュコマンド専用）
* allowed-tools: `Bash(git status:*)` `Bash(git diff:*)` `Bash(git log:*)` `Bash(git branch:*)` `Bash(git fetch:*)` `Bash(git rev-parse:*)` `Bash(git remote:*)` `Bash(git push -u:*)` `Bash(git push --force-with-lease:*)` `Bash(gh repo view:*)` `Bash(gh pr view:*)` `Bash(gh pr edit:*)` ＋ Read / Glob / Grep / Skill。実行系と Write / Edit は載せない（R6）

**手順 1 — 現状確認**（並列実行）: `git status -uall` / `git diff` と `git diff --cached` / `git log --oneline -10` / `git branch --show-current` / `gh pr view --json url,state,title,body,baseRefName` / `git remote -v`。

* 前提条件の確認: 現ブランチに open な PR が無ければ create-pr へ委譲して終了する
* `<remote-default-ref>` の確定手順は §5.2 手順 1 と同じ内容を**このスキルの本文にも書く**（R9 のため、他スキルの本文を参照させない）

**手順 2 — モードの決定**: ユーザーが履歴の組み直しを明示的に求めている場合（「コミットを整理してから push し直して」等）は**再編モード**、それ以外は**追記モード**。追記モードで未コミット変更が無い場合は、未 push コミットがあれば手順 5 へ、それも無ければ「更新対象なし」と報告して終了。

**手順 3 — 検証**: check-build / check-format / check-lint / check-test / check-review を呼ぶ。中断基準は §5.2 手順 2 と同じ。

**手順 4 — コミット**:

* 追記モード: atomic-commit を呼ぶ。伝える内容は §5.2 手順 4 と同じ
* 再編モード: rework-commit を呼ぶ（バックアップ作成・push 済み確認・同一性確認は rework-commit と reset-commit の手順に含まれる）

**手順 5 — push**: 追記モードは `git push -u origin HEAD`。再編モードは `git push --force-with-lease`。**素の `--force` は使わない。**

**手順 6 — PR body 同期**: `git log --oneline <remote-default-ref>..HEAD` と PR の title / body を突き合わせ、実態とずれていれば `gh pr edit` で更新する。タイトルと body の規約は §5.2 手順 5 と同じ。

**手順 7 — 報告**: 使用したモード / 作成・再編したコミット / 実行した検証 / push の種類（通常 or force-with-lease）/ PR の URL。

### 5.4 merge-pr

open な PR をマージまで持っていくスキル。

**frontmatter**

* description: PR のマージに使う旨（トリガー: 「マージして」「マージまで見といて」「merge the PR」等）＋修正は行わない旨（修正は update-pr）
* argument-hint: `[pr-number]`（省略時は現ブランチの PR）
* disable-model-invocation: true（スラッシュコマンド専用）
* allowed-tools: `Bash(git fetch:*)` `Bash(git log:*)` `Bash(git rev-parse:*)` `Bash(gh repo view:*)` `Bash(gh pr view:*)` `Bash(gh pr checks:*)` `Bash(gh pr update-branch:*)` `Bash(gh pr merge:*)` ＋ Read / Grep / Glob。`gh pr merge` を載せるのはこのスキルだけ（R5）

**前提条件**: 対象の PR（引数指定、無ければ現ブランチ）が open である。無ければその旨を報告して終了。draft の場合はマージできないため、ready 化してよいかユーザーへ確認する。

**手順 1 — 状態確認**: `gh pr view --json state,isDraft,mergeable,mergeStateStatus,reviewDecision,url,headRefName,baseRefName` と `gh pr checks`。

**手順 2 — base 追従**: base ブランチから遅れている・conflict している場合は `gh pr update-branch` で base を取り込む。conflict で自動更新できない場合は、conflict の内容を報告して停止する（解決はこのスキルの責務ではない — R4 と同様、このスキルはコードを変更しない）。

**手順 3 — CI 確認**: `gh pr checks --watch` で完了を待つ。失敗があれば要点を報告して中断する（修正は update-pr の仕事）。

**手順 4 — マージ実行**: マージは取り消せないため、**実行直前に対象 PR とマージ方式をユーザーへ最終確認する**。方式はリポジトリで許可されているもの（`gh repo view --json squashMergeAllowed,mergeCommitAllowed,rebaseMergeAllowed`）から、ユーザー指定があればそれを優先する。CI 待ちが長い場合は、確認を得たうえで `gh pr merge --auto` を使ってよい。ブランチ削除（`--delete-branch`）はユーザーが求めた場合のみ。

**手順 5 — 報告**: マージ結果 / 使用した方式 / auto-merge 使用の有無 / ブランチ削除の有無。

## 6. settings.yaml の変更

`claude/settings.yaml` の既存 `permissions:` キーの配下に deny を追加する（`allow` の内容には手を付けない）。

```yaml
permissions:
  deny:
  - "Bash(git push -f:*)"
```

* push / merge 系コマンドは allow に入れない（毎回の確認プロンプトに落とすため）
* 素の `--force` を deny しないのは意図的: 許可パターンは文字列の先頭一致であり、`git push --force` を deny すると、より安全な `git push --force-with-lease`（update-pr が履歴再編後にユーザー確認を経て使う）まで一致して封じてしまう。素の `--force` はどのスキルの本文・allowed-tools にも存在せず、出現しても allow に無いため確認プロンプトで止まる

## 7. 作成手順（1 ステップ = 1 コミット）

| # | 作業 | 対象ファイル |
|---|---|---|
| 1 | reset-commit 新規作成（§3.2） | `claude/skills/reset-commit/SKILL.md` 新規 |
| 2 | atomic-commit を §3.1 の内容で置き換え | `claude/skills/atomic-commit/SKILL.md` 置換、`claude/skills/atomic-commit/references/splitting.md` 削除（内容は §3.1 に統合済み） |
| 3 | rework-commit を §5.1 の内容で置き換え | `claude/skills/rework-commit/SKILL.md` 置換 |
| 4 | toolchain 駆動チェック 4 スキルを新規作成（§4.1） | `claude/skills/check-{build,format,lint,test}/SKILL.md` 新規 |
| 5 | check-review 新規作成（§4.2） | `claude/skills/check-review/SKILL.md` 新規 |
| 6 | create-pr を §5.2 の内容で置き換え | `claude/skills/create-pr/SKILL.md` 置換 |
| 7 | update-pr 新規作成（§5.3） | `claude/skills/update-pr/SKILL.md` 新規 |
| 8 | merge-pr 新規作成（§5.4） | `claude/skills/merge-pr/SKILL.md` 新規 |
| 9 | redundant-comment-sweep の検証を置換 | `claude/skills/redundant-comment-sweep/SKILL.md` 部分修正 |
| 10 | permissions へ deny 追加（§6） | `claude/settings.yaml` 編集 |

* コミットは Conventional Commits（scope: skills）
* 手順 2 の時点では atomic-commit の検証の参照先（check-*）がまだ存在しないため、手順 4〜5 の後に参照が成立する旨を注記するか、手順 4〜5 を先に実施してもよい
* 手順 6〜8 のスキルは互いを名前で参照するが、参照は実行時に解決されるため作成順序の制約はない
* 手順 9 の内容: ラウンド内で formatter / lint / ビルド / テストのコマンドを直接実行・列挙している検証記述を、check-build / check-format / check-lint / check-test の呼び出しに置き換える（R3）。コミット工程（atomic-commit 使用）と他の手順は変更しない

**完了チェックリスト**

* 全 SKILL.md 本文に「〜から呼ばれた場合」が存在しない（R1）
* rework-commit 経由でも単独でも atomic-commit の手順記述が同一（R1）
* rework-commit に自前の git 操作が無い（最終確認の diff を除く）
* `splitting.md` が存在しない
* ビルド・format・lint・テストのコマンド一覧を本文に持つのは check-build / check-format / check-lint / check-test だけ（R3）
* check-* にリポジトリを変更する記述が無い（R4）
* 素の `git push --force` がどのスキルの本文・allowed-tools にも存在しない。force は update-pr の `--force-with-lease` のみ（R5）
* `gh pr merge` を載せているのは merge-pr だけ。merge-pr は実行直前にユーザーへ最終確認する（R5）
* allowed-tools に `Bash(git:*)` / `Bash(gh:*)` が無い（R6）
* reset-commit が push 済みコミットの reset 前に確認を挟む（R2）
* どのスキルもスキルディレクトリ外のファイルを参照していない（R9）
* redundant-comment-sweep の検証が check-* 呼び出しになっている（R3）
* 各ステップが独立したコミットになっている

## 付録: 検討の記録（要約）

再検討の材料。結論ではなく論拠を残す。

* **例外記述の原因** — スキルの契約を「呼び出し元が誰か」で書くと打ち消しの例外が要る。「呼び出し時点の状態」で書くと条件が自己評価できて例外が消える（例: 「既存コミットを書き換えない」→「呼び出し時点の HEAD より前に触れない」は、reset 直後でも単独でも同じ文で正しい）。分割の変更はこの問題の解決には必須でない
* **分割の軸** — 検証は「toolchain × 種類」の行列。行（toolchain）はリポジトリ依存なのでスキルに割ると選択が全呼び出し元へ漏れる（→各 check スキル本文内の検出表へ）。列（build / format / lint / test / review）は全リポジトリ共通なのでスキルに割ってよい（review のように toolchain 非依存の列もある）。工程割り（analyze の分離）は、計画が実行中に見直されるループなので不採用
* **調査系スキル** — 不採用。封じ込める手続き知識が無く（`git status` は 1 コマンド）、スキルには型付き戻り値が無く、「調べる」は単独の意図にならずトリガーが成立しない。唯一の本物の知識（remote-default-ref 確定）は、共有リファレンス化が R9 を壊すため、必要とする各オーケストレーターの本文に重複掲載する
* **オーケストレーターの要否** — 両案成立。廃止案（状態駆動連鎖: reset 後は「未コミット変更がある」状態なので次のスキルは状態から自明）も可能だが、「意図 1 つにスキル 1 つ」の対応表と end-to-end 検証（R8）のオーナーを残すため薄い維持を選択。例外を生む原因はオーケストレーターの存在ではなく、自前作業を持ちながら残りを委譲すること（→設計原則 4）
* **セキュリティ境界** — スキル分割は権限境界にならない（Skill は同一会話への手順書差し込みで、道具はセッションの権限設定で決まる。allowed-tools は檻ではなく通行証）。封じ込めは settings.yaml の permissions・hooks・subagent の tools 制限で行い、allowed-tools は通行証の最小化（R6）として使う
* **命名** — verify（目的語なし）、run-checks（対象が曖昧）、soft-reset-commit（実装は mixed reset で soft でない）、auto-merge-pr（機構が名前に漏れる）を却下してきた経緯から R7 を導出
* **知識の置き場** — 分冊（リファレンス）が正当なのは「複数スキルで共有」か「状況により読まない大きな塊」。単独消費者が必ず読む知識は本文へ（splitting.md を統合した理由）。検証コマンドの行列も、列で割った時点で各列の消費者が 1 スキルになったため共有ファイル（toolchains.md 案）を取りやめ、各 check スキルの本文へ配った。共有として残るのは検出表 6 行だけで、分冊に値しない。加えて共有リファレンスはスキルディレクトリ単体の配布（R9）を壊す。toolchain 追加時の編集は 1 ファイル 1 行から 4 ファイル各 1 行に増えるが、追加はどのみち全種類のコマンド記述を伴い、書き忘れても該当 check が「検証対象なし」と報告する軟らかい劣化で済む。atomic-commit のコミット単位検証も当初は rebase --exec 用にコマンドを自前で組み立てる案だったが、コミットを checkout して check-* を呼ぶ巡回に変えて委譲へ統一した（副産物としてハッシュが保存され、rebase の復旧手順も不要になった）
* **force-push の deny** — 当初は `--force` と `-f` の両方を deny する案だったが、update-pr（履歴再編後の push）が `--force-with-lease` を必要とし、先頭一致のパターンでは `--force` の deny が `--force-with-lease` まで封じるため、deny は `-f` のみとした（§6 の注記参照）
