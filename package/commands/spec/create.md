---
name: 機能仕様書作成
argument-hint: [phase-number]
---

要求定義書を作成します。

ユーザーから受けたコンテキストから以下を実行してください。

1. テンプレート(`.spec/template/spec.md`)を`.spec/work/$1/spec.md`にコピーする
2. `.spec/work/$1/spec.md`を読み込んで内容を理解してください。
3. `.spec/work/$1/requirements.md`を読み込んで内容を理解してください。
4. 読み込んだ要求定義書から機能仕様書を作成してください。
5. 関連するドキュメントを更新してください。