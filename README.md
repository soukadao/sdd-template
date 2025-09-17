# 仕様駆動開発テンプレート

> [!CAUTION]
> このリポジトリは作成中です

## リポジトリ構成

- commands: コマンド
- template: テンプレート
- example: 仕様駆動開発例

```
.
├── commands
│   ├── requirements
│   │   ├── create.md
│   │   └── update.md
│   ├── spec
│   │   ├── create.md
│   │   └── update.md
│   └── task
│       ├── create.md
│       ├── execute.md
│       └── update.md
├── example
│   └── work
│       ├── common
│       │   ├── constraints.md
│       │   ├── techstack.md
│       │   └── testing.md
│       ├── phase-1
│       │   ├── kanban.md
│       │   ├── requirements.md
│       │   ├── spec.md
│       │   └── tasks
│       │       ├── 001-feature-name
│       │       │   └── task.md
│       │       └── 002-feature-name
│       │           └── task.md
│       └── phase-2
│           ├── kanban.md
│           ├── requirements.md
│           ├── spec.md
│           └── tasks
│               ├── 001-feature-name
│               │   └── task.md
│               └── 002-feature-name
│                   └── task.md
├── policy.md
├── README.md
├── scripts
│   └── init.sh
└── template
    ├── kanban.md
    ├── requirements.md
    ├── spec.md
    └── task.md
```

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
├── common
│   ├── constraints.md
│   ├── techstack.md
│   └── testing.md
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

## 持ち越しの考え方

TODO:

次のフェーズを作成するタイミングで`Backlog`のタスクがあれば持ち越しとみなす？
要求の変更や仕様の変更にどう対応するか？