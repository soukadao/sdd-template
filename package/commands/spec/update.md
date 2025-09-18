---
name: 機能仕様書更新
argument-hint: [phase-number] [context]
---

機能仕様書を更新します。

ユーザーから受けたコンテキストから以下を実行してください。

**重要**: テンプレートのコメントは消さないこと

1. `.spec/work/$1/spec.md`を読み込んで内容を理解してください。
2. 読み込んだ内容を元にユーザーから受けた内容で更新をしてください。
3. 関連ドキュメントを更新してください。

**更新対象の関連ドキュメント**

- `.spec/work/common/teckstack.md`
- `.spec/work/common/testing.md`