---
name: rework-commit
description: Reorganize the current branch's existing commit history into logical, atomic commits (create a backup branch first, never push, keep the final tree identical). Use when commits already exist and the user wants them split, restructured, or cleaned up before review — phrases like "コミット整理して", "コミット分割して", "履歴を綺麗にして", "コミットまとめ直して", "split commits", "clean up git history", "rework commit history", "make this PR reviewable". Do NOT use when the changes are still uncommitted in the working tree (use atomic-commit), or for writing a single commit message, resolving merge conflicts, reverting changes, or merging branches.
---

# rework-commit

あなたはGit履歴の再編を担当します。

現在のブランチには、要求された機能の実装と動作確認が完了したコミットが積まれています。
これを論理的かつatomicな単位のコミットへ再編してください。

## 目的

レビュー、revert、bisect、cherry-pickが容易になるように、既存の履歴を意味のある最小単位へ組み替えます。

このスキルが担当するのは**履歴を安全に書き換えるための外枠**です。
「変更をどの単位へ分けるか」の判断と実際のコミット作成は `atomic-commit` スキルへ委譲します。

## 最重要制約

* 作業開始前に、現在のHEADを指すバックアップブランチまたはタグを作成すること
* リモートブランチへpushしないこと
* force pushしないこと
* main、master、developなど共有ブランチを変更しないこと
* 最終的なworking treeの内容を、再編前の状態から変更しないこと
* 機能追加、バグ修正、追加リファクタリングを行わないこと
* コミット再編に不要なコード変更を行わないこと
* 変更内容を失う可能性がある操作を、バックアップ作成前に実行しないこと

まだコミットされていない変更をコミットするだけであれば、履歴の書き換えは不要です。その場合はこのスキルではなく `atomic-commit` を直接使用してください。

## 作業手順

### 1. 現状確認

* 現在のブランチ名と、それが共有ブランチでないこと
* ベースブランチまたは分岐元コミット
* ベースとの差分
* 現在のコミット履歴
* staged、unstaged、untrackedファイルの有無
* 実行可能なビルド、lint、テストコマンド

ベースコミットが明確でない場合は、merge-base、ブランチ履歴、リモート追跡ブランチを調査して合理的に特定してください。
特定したベースコミットは、以降の手順すべてで同じものを使います。

### 2. バックアップ

未コミットの変更も再編の対象に含めます。したがってバックアップは**HEADではなく、未コミット・未追跡を含めた作業開始時点のファイル内容全体**を指す必要があります。手順5の最終ツリー比較は、このバックアップを基準に行います。

以下の手順でスナップショットコミットを作り、それを指すバックアップブランチを作成してください。

```bash
git add -A
git branch backup/rework-commit-<timestamp> \
  "$(git commit-tree "$(git write-tree)" -p HEAD -m 'snapshot before rework-commit')"
git reset
```

* `git commit-tree` は履歴上のどのブランチにも接続されない独立したコミットを作るため、現在のブランチには影響しません
* `git add -A` により未追跡ファイルもスナップショットへ含まれます。`.gitignore` されたファイルは含まれないため、生成物などで別途保護が必要なものがあれば個別に退避してください
* 最後の `git reset` でindexを作業開始時点相当へ戻します（この直後の手順3でどのみちベースコミットへresetします）

作成後、`git rev-parse backup/rework-commit-<timestamp>` でバックアップブランチが存在することを確認してください。

バックアップ名の例:

`backup/rework-commit-<timestamp>`

### 3. ベースコミットへのreset

バックアップブランチが存在することを確認したうえで、`git reset <ベースコミット>` を実行してください。
HEADはベースコミットへ戻り、全変更はunstagedとしてworking treeに残ります。

`git rebase -i` は使用しないでください。editorの対話操作を前提とするため、非対話環境では失敗します。やむを得ず使用する場合のみ、`GIT_SEQUENCE_EDITOR` に非対話コマンドを設定してください。

ベースコミット以降に新規追加されたファイルは、reset後にuntrackedになります。`git status -uall` で見落としがないことを確認してください。

### 4. コミットの再構築

`atomic-commit` スキルを呼び出し、その手順に従ってworking treeの変更を論理単位のコミットへ再構築してください。

`atomic-commit` へ以下を伝えてください。

* **`rework-commit` から呼び出されていること。バックアップ作成とベースコミットへのresetは実施済みであり、`rework-commit` へ差し戻す必要はないこと**（`atomic-commit` 側に例外規定があります）
* 手順1で特定したベースコミット
* 手順2で作成したバックアップブランチ名
* 再編前の履歴と、そこから読み取れる変更の意図
* 実行可能なビルド、lint、テストコマンド

コミット単位の検証も `atomic-commit` の手順に含まれます。方法Bの一括検証を使う場合は、`git rebase <ベースコミット> --exec '<検証コマンド>'` の起点に手順1のベースコミットを指定してください。

### 5. 最終確認

再編完了後、以下を確認してください。

* **再編前バックアップと再編後HEADの最終ツリーが同一であること**
* 意図しないファイル差分がないこと
* working treeがcleanであること
* 全体のビルド、lint、テストが成功すること
* コミット順序が依存関係に沿っていること
* 各コミットが1つの論理的目的を持つこと
* コミットメッセージが変更内容と一致していること

最終ツリーの同一性は、可能であれば以下のような方法で機械的に確認してください。

* tree object IDの比較
* `git diff <backup-branch> HEAD`
* 必要に応じて生成物や除外ファイルも含めた追加確認

`git diff <backup-branch> HEAD` は、履歴ではなく最終ファイル内容について差分がない状態にしてください。

## 完了報告

1. 作成したバックアップブランチ名
2. 特定したベースコミット
3. 再編前と再編後のコミット数
4. 再編後のコミット一覧
5. 各コミットの目的
6. 各コミットで実行した検証
7. 最終状態で実行した検証
8. 再編前後の最終ツリーが同一であることの確認結果
9. 実行しなかった検証と、その理由
10. 残っているリスクまたは判断が必要な事項

## 判断基準

不明点があっても、まずリポジトリと履歴から判断材料を収集してください。
破壊的操作が必要になる場合のみ、実行前に停止して確認してください。
