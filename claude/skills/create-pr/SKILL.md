---
name: create-pr
description: Create a branch, commit changes in Conventional Commits format, and create a pull request. Use when the user asks to create a PR, submit changes, or send code for review.
argument-hint: [branch-name]
disable-model-invocation: true
allowed-tools: Bash(git:*), Bash(gh:*), Bash(cargo:*), Bash(npm:*), Bash(go:*), Bash(gofmt:*), Bash(make:*), Bash(task:*), Bash(ls:*), Bash(test:*), Read, Glob, Grep, Write, Edit, Skill
---

# Create Pull Request

ブランチを作成し、Conventional Commits 形式でコミットし、PR を作成する。

## 手順

### 1. 現状確認

以下のコマンドを**並列**で実行して現状を把握する:

- `git status -uall` — 未追跡・変更ファイルを個別に確認する（ディレクトリ単位に折り畳まれると見落とすため）
- `git diff` + `git diff --cached` — ステージ済み・未ステージの変更内容
- `git log --oneline -10` — 最近のコミット履歴
- `git branch --show-current` — 現在のブランチ名
- `gh repo view --json defaultBranchRef,nameWithOwner` — デフォルトブランチと対象リポジトリ
- `git remote -v` — push 先と upstream の有無

コミットすべき変更がない場合は、その旨を伝えて終了する。

#### コミット範囲の起点となる ref を確定する

以降の手順で使う `<remote-default-ref>` を、ここで 1 つに確定する。ローカルブランチ名（`main` など）は使わない。ローカルに同名ブランチが存在しない場合は `unknown revision` で失敗し、存在しても古ければ範囲がずれるため。

- fork 運用（`origin` が自分の fork、`upstream` が本家）の場合: `upstream/<default-branch>`
- それ以外: `origin/<default-branch>`

`git rev-parse --verify <remote-default-ref>` で解決できることを確認する。解決できない場合は `git fetch <remote> <default-branch>` を実行してから再確認する。

### 2. ビルド検証

リポジトリ内のファイルから使用ツールを検出し、該当するチェックのみ実行する。
該当ファイルが無い、またはコマンドが定義されていない場合はスキップする。

| 検出ファイル                | 実行するチェック                                                                                        |
| --------------------------- | ------------------------------------------------------------------------------------------------------- |
| `Cargo.toml`                | `cargo test --quiet`, `cargo clippy --all-targets --all-features --quiet`, `cargo fmt --all -- --check` |
| `package.json`              | `package.json` の `scripts` に存在するものだけ: `npm test`, `npm run lint`, `npm run typecheck`         |
| `go.mod`                    | `go test ./...`, `go vet ./...`, `gofmt -l .`                                                           |
| `Makefile` / `Taskfile.yml` | `test` / `lint` / `check` 相当のターゲットが存在すればそれを使う                                        |

上記のいずれにも該当しない場合は、CI 定義（`.github/workflows/`）を確認し、そこで実行されているチェックをローカルで再現できる範囲で実行する。

**テストやリントが失敗した場合は、PR 作成を中断し、問題を報告する。**

### 3. ブランチ作成

判定は以下の順に行う（上の条件が成立したら下は評価しない）。

1. **引数 `$ARGUMENTS` が指定されている場合**はそのブランチ名を使う。現在のブランチがデフォルトブランチ以外であっても、明示指定を優先する
   - 現在のブランチ名が指定と一致する場合は何もしない
2. **現在のブランチがデフォルトブランチ以外の場合**は、新しいブランチを作成せずそのブランチを使う
   - デフォルトブランチは手順 1 の `gh repo view` の結果で判定する（`main` / `master` 決め打ちにしない）
3. **上記以外**（デフォルトブランチ上かつ引数なし）は、変更内容から適切なブランチ名を生成する
   - 形式: `<type>/<short-description>` (例: `feat/add-user-auth`, `fix/null-pointer-in-parser`)

ブランチ作成は `git switch -c <branch-name>`。

同名ブランチが既に存在する場合は、切り替える前に `git log --oneline <remote-default-ref>..<branch-name>` でそのブランチ独自のコミットを確認する。

- **独自のコミットが無い場合**（デフォルトブランチと同位置または後ろ）: `git switch <branch-name>` で切り替えてよい
- **独自のコミットがある場合**: マージ済み・放棄済みの過去の作業が PR に混入するため、そのまま切り替えない。別名（`<branch-name>-2` など）を使うか、ユーザーへ確認する

### 4. コミット作成

変更内容を分析し、Conventional Commits 形式でコミットメッセージを作成する。

#### Conventional Commits 形式

```
<type>[optional scope]: <description>

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

#### Type の選択基準

| Type | 用途 |
|------|------|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（空白、フォーマット等） |
| `refactor` | バグ修正でも機能追加でもないコード変更 |
| `perf` | パフォーマンス改善 |
| `test` | テストの追加・修正 |
| `build` | ビルドシステムや外部依存の変更 |
| `ci` | CI 設定ファイルやスクリプトの変更 |
| `chore` | その他の変更 |

#### ルール

- description は英語で簡潔に（70文字以内）
- body には「なぜ」この変更が必要かを書く（「何を」変えたかではない）
- 複数の論理的変更がある場合は、分割コミットを検討する
- `.env`, `credentials.json` 等の機密ファイルはコミットしない（警告を出す）
- HEREDOC 形式でコミットメッセージを渡す:

```bash
git commit -m "$(cat <<'EOF'
<type>[scope]: <description>

<body>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### 5. プッシュと PR 作成

#### 5-1. リモート確認

- 手順 1 の `git remote -v` の結果で push 先を確認する
- fork 運用（`origin` が自分の fork、`upstream` が本家）の場合は、push 先は `origin`、PR の base は upstream 側のデフォルトブランチになる
- `git push -u origin HEAD` でリモートにプッシュ

#### 5-2. 既存 PR の確認

`gh pr view --json url,state` で現在のブランチの PR を確認する。

**このコマンドは PR が存在しない場合 `no pull requests found for branch` を出力して非ゼロ終了する。これは正常系であり、エラーとして報告・中断しない。**

- **既に open な PR がある場合**: `gh pr create` は実行せず、push のみで完了とし、既存 PR の URL を報告する
- **PR が無い場合（非ゼロ終了を含む）**: 以下の手順で新規作成する

#### 5-3. PR 作成

`.github/PULL_REQUEST_TEMPLATE.md`（または `.github/pull_request_template.md`）が存在する場合は、
そのテンプレートの構成に従って body を作成する。存在しない場合は以下の形式を使う。

```bash
gh pr create --base <default-branch> --title "<type>[scope]: <description>" --body "$(cat <<'EOF'
## Summary
<Changes in bullet points>

## Test plan
<Testing Methodology Checklist>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

fork 運用の場合は、上記に加えて `--repo <upstream の nameWithOwner>` と `--head <自分の owner>:<branch-name>` を必ず指定する。省略すると fork 側に PR が作られるか、push 先を尋ねる対話プロンプトで非対話実行がハングする。

#### ルール

- `--base` には手順 1 で取得したデフォルトブランチ名（ref ではなくブランチ名）を明示的に指定する
- title は英語で Conventional Commits 形式と同じ type prefix を使う
- title は 70 文字以内に収める
- body は英語で記載する

### 6. 完了報告

以下を報告する:

- ブランチ名
- 作成したコミット（`git log --oneline <remote-default-ref>..HEAD` の結果）
- 実行したビルド検証とその結果（スキップした場合はその旨）
- PR の URL
