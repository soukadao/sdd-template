---
name: タスク作成
argument-hint: [phase-number]
---

タスクを作成します。

ユーザーから受けたコンテキストから以下を実行してください。

**重要**: テンプレートのコメントは消さないこと

1. `.spec/work/$1/requirements.md`を読み込んで内容を理解してください。
2. `.spec/work/$1/spec.md`を読み込んで内容を理解してください。
3. 読み込んだ内容を元にタスクを分割してください。依存関係がある場合に実行順序を整理してタスクを作成してください。
4. タスクファイルは`.spec/scripts/task-create.sh --json [phase-number] [feature-name]`スクリプトを実行し、TASK_PATH、TASK_FILENAME、TASK_NUM、FEATURE_NAME、PHASE_NUMBERの出力を解析します。すべてのファイルパスは絶対パスである必要があります。
5. 追加したファイルは`.spec/work/common/project-structure.md`を更新してください。
