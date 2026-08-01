---
name: atomic-commit
description: Commit the working tree's uncommitted changes as logical, atomic commits (never rewrite existing history, never push). Use when implementation is done and the changes still sit in the working tree — phrases like "いい感じにコミットして", "コミットして", "変更をコミットに分けて", "commit this properly", "split these changes into commits". Also used by other skills that need a commit step. Do NOT use for rewriting commits that already exist (use rework-commit), writing a single commit message for an already-staged change, resolving merge conflicts, or merging branches.
---

# atomic-commit

あなたはコミット作成を担当します。

現在のworking treeには、実装と動作確認が完了した未コミットの変更があります。
これを論理的かつatomicな単位のコミットへ分けて作成してください。

## 目的

レビュー、revert、bisect、cherry-pickが容易になるように、変更を意味のある最小単位へ分割してコミットします。

atomic commitの定義、変更の分類観点、hunk単位のstage手順、コミットメッセージ規約、分割の判断基準は、このスキルディレクトリ内の `references/splitting.md` に記載しています。**作業前に必ず読んでください。**

## 最重要制約

* 既存のコミットを書き換えないこと。新規コミットのみを作成すること
* リモートブランチへpushしないこと
* main、master、developなど共有ブランチへコミットしないこと。作業ブランチ上にいない場合は、開始前にユーザーへ確認すること
* 機能追加、バグ修正、追加リファクタリングを行わないこと
* コミット作成に不要なコード変更を行わないこと
* 最終的なworking treeの内容を、作業開始前の状態から変更しないこと

既にコミット済みの履歴を分割・再編する必要がある場合は、このスキルではなく `rework-commit` を使用してください。

**例外: `rework-commit` から呼び出された場合**

`rework-commit` から呼び出された場合、履歴の書き換え（バックアップ作成とベースコミットへのreset）は呼び出し元が実施済みです。あなたが受け取るのは、resetによってworking treeへ展開された未コミットの変更です。この状況では `rework-commit` へ差し戻さず、通常どおり手順1から作業を進めてください。上記の「既存のコミットを書き換えないこと」は、reset後のHEAD以降にあなたが作成するコミットに対する制約として解釈してください。

## 作業手順

### 1. 現状確認

以下を確認してください。

* 現在のブランチ名と、それが共有ブランチでないこと
* `git status -uall` — staged、unstaged、untrackedファイル。ディレクトリ単位に折り畳まれると未追跡ファイルを見落とすため `-uall` を使う
* `git diff` と `git diff --cached` — 変更内容
* `git log --oneline -10` — 既存のコミットメッセージ規約
* 実行可能なビルド、lint、テストコマンド
* 変更によって実現された要求事項

コミットすべき変更がない場合は、その旨を伝えて終了してください。

### 2. 変更の分析とコミット計画

`references/splitting.md` の分類観点に従って差分を分析し、コミット計画を提示してください。
計画に記載する項目と、コミット順序の原則も同ファイルに記載しています。

### 3. コミット作成

コミット計画の順序どおりに、stageとcommitを繰り返してください。

* パスを明示して `git add <ファイル>` する
* 同一ファイル内に複数の論理変更が混在する場合は、`references/splitting.md` のhunk単位のstage手順に従う
* commit前に `git diff --cached` でstage内容が計画と一致することを確認する

### 4. 検証

可能な限り、各コミットについて formatter、lint、type check、unit test、build を実行してください。

reset方式ではなくworking treeから順にコミットするため、コミット作成直後のworking treeには後続コミット予定の変更が残っています。そのまま検証してもそのコミット単体の検証にはなりません。以下のいずれかの方法を使ってください。

**方法A: コミットごとに退避して検証する**

1. コミット作成直後に `git stash push -u` で残りの変更を退避する
2. 検証コマンドを実行する
3. `git stash pop` で変更を復元し、次のコミット作業へ進む

検証がファイルを生成または変更する場合は、`git stash pop` の前にworking treeを検証前の状態へ戻してください。

**方法B: 全コミット作成後に一括で検証する**

すべてのコミットを作成した後、`git rebase <開始時点のコミット> --exec '<検証コマンド>'` を実行してください。各コミットをcheckoutした状態で検証コマンドが順に実行され、失敗したコミットで停止します。

この方法は**あなたがこのセッションで作成したコミットのみを対象**とします。`<開始時点のコミット>` には必ず作業開始時のHEAD（呼び出し元から指定されている場合はそのベースコミット）を指定してください。それより前を起点にすると、書き換えてはならない既存コミットまでrebaseの対象になります。なお、検証が全て成功した場合でも、rebaseの性質上あなたが作成したコミットのハッシュは変わります。内容は変わらないため、最重要制約には反しません。ハッシュを変えたくない場合は方法Aを使ってください。

停止した場合はコミット境界を見直し、修正後に `git rebase --continue` で再開してください。修正の見通しが立たない場合は、`git rebase --abort` でrebase開始前の状態へ戻し、rebase途中のまま放置しないでください。abortした場合は、検証が未完了である事実を完了報告に含めてください。

**検証を省略してよい場合**

呼び出し元のスキルやユーザーが、コミット作成の直前に変更全体のビルド・lint・テストを実行済みで、その結果が成功している場合は、コミット単位の検証を省略して最終状態の確認のみとしてかまいません。省略した事実は完了報告に含めてください。

各コミットでビルドやテストを成功させられない場合は、安易に無視せず、次のいずれかを行ってください。

* コミット境界を見直す
* 依存する変更を同じコミットへ統合する
* そのコミット単独では検証できない理由を明示する

テストを意図的に失敗させるコミットは、明示的に要求されていない限り作成しないでください。

### 5. 最終確認

* working treeがcleanであること。意図せず未コミットで残った変更がないこと
* 作業開始時点と最終コミット時点で、ファイル内容が一致していること
* コミット順序が依存関係に沿っていること
* 各コミットが1つの論理的目的を持つこと
* コミットメッセージが変更内容と一致していること

## 完了報告

1. 作成したコミット一覧（`git log --oneline`）
2. 各コミットの目的
3. 各コミットで実行した検証
4. 最終状態で実行した検証
5. 実行しなかった検証と、その理由
6. コミットしなかった変更があればその内容と理由
7. 残っているリスクまたは判断が必要な事項
