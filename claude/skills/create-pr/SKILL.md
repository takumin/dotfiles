---
name: create-pr
description: Create a branch, commit changes in Conventional Commits format, and create a pull request. Use when the user asks to create a PR, submit changes, or send code for review.
argument-hint: [optional: branch-name]
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *), Bash(cargo *)
---

# Create Pull Request

ブランチを作成し、Conventional Commits 形式でコミットし、PR を作成する。

## 手順

### 1. 現状確認

以下のコマンドを**並列**で実行して現状を把握する:

- `git status` — 未追跡・変更ファイルの確認（`-uall` フラグは使わない）
- `git diff` + `git diff --cached` — ステージ済み・未ステージの変更内容
- `git log --oneline -10` — 最近のコミット履歴
- `git branch --show-current` — 現在のブランチ名

コミットすべき変更がない場合は、その旨を伝えて終了する。

### 2. ビルド検証

変更内容に応じて、以下のチェックを実行する:

- Rust プロジェクト: `cargo test --quiet`, `cargo clippy --all-targets --all-features --quiet`, `cargo fmt --all -- --check`
- Node.js プロジェクト: `npm test`, `npm run lint`（存在する場合）
- Go プロジェクト: `go test ./...`, `go vet ./...`

**テストやリントが失敗した場合は、PR 作成を中断し、問題を報告する。**

### 3. ブランチ作成

- 引数 `$ARGUMENTS` が指定されている場合はそのブランチ名を使用する
- 指定がない場合は変更内容から適切なブランチ名を生成する
  - 形式: `<type>/<short-description>` (例: `feat/add-user-auth`, `fix/null-pointer-in-parser`)
- 既に main/master 以外のブランチにいる場合は、新しいブランチを作成せずそのブランチを使う
- ブランチ作成: `git checkout -b <branch-name>`

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

- `git push -u origin <branch-name>` でリモートにプッシュ
- `gh pr create` で PR を作成する

#### PR フォーマット

```bash
gh pr create --title "<type>[scope]: <description>" --body "$(cat <<'EOF'
## Summary
<Changes in bullet points>

## Test plan
<Testing Methodology Checklist>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

#### ルール

- title は 英語で Conventional Commits 形式と同じ type prefix を使う
- title は 70 文字以内に収める
- body は英語で記載する

### 6. 完了報告

PR の URL を表示して完了を報告する。
