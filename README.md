# 仕様駆動開発テンプレート

> [!CAUTION]
> このリポジトリは作成中です

## リポジトリ構成

- commands: コマンド
- template: テンプレート
- example: 仕様駆動開発例

## 開発フロー案

```mermaid
flowchart LR
    requirements["要求定義"]
    spec["仕様定義"]
    task["タスク化"]
    execute["タスク実行"]
    requirements --> spec
    spec --> task
    task --> execute
```

## 仕様駆動開発の構成案

```
work
├── phase-1
│   ├── kanban.md
│   ├── requirements.md
│   ├── spec.md
│   └── tasks
│       ├── 001-feature-name
│       │   └── task.md
│       └── 002-feature-name
│           └── task.md
└── phase-2
    ├── kanban.md
    ├── requirements.md
    ├── spec.md
    └── tasks
        ├── 001-feature-name
        │   └── task.md
        └── 002-feature-name
            └── task.md
```