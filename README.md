# 仕様駆動開発テンプレート

> [!CAUTION]
> このリポジトリは作成中です

## リポジトリ構成

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
│       │   ├── project-structure.md
│       │   ├── techstack.md
│       │   └── testing.md
│       ├── phase-00001
│       │   ├── kanban.md
│       │   ├── requirements.md
│       │   ├── spec.md
│       │   └── tasks
│       │       ├── 001-feature-name
│       │       │   └── task.md
│       │       └── 002-feature-name
│       │           └── task.md
│       └── phase-00002
│           ├── kanban.md
│           ├── requirements.md
│           ├── spec.md
│           └── tasks
│               ├── 001-feature-name
│               │   └── task.md
│               └── 002-feature-name
│                   └── task.md
├── README.md
├── scripts
│   └── init.sh
├── template
│   ├── kanban.md
│   ├── requirements.md
│   ├── spec.md
│   └── task.md
└── work
    └── common
        ├── constraints.md
        ├── policy.md
        ├── project-structure.md
        ├── techstack.md
        └── testing.md
```

## 使用方法

### 初回セットアップ

```bash
npx git+https://github.com/soukadao/sdd-template.git
```

### 要求仕様書を作成する

Claude Code を使用する場合

```
> /requirements:create 足し算ができるようにしたい
```

## 開発フロー案

```mermaid
sequenceDiagram
    participant Dev as 開発者
    participant Req as 要求定義
    participant Spec as 仕様定義
    participant Task as タスク化
    participant Exec as タスク実行

    Dev->>Req: 要求を定義
    loop 要求の詳細化
        Req->>Req: 要求を更新
    end

    Req->>Spec: 要求から仕様を作成
    loop 仕様の詳細化
        Spec->>Spec: 仕様を更新
    end

    Spec->>Task: 仕様からタスクを作成
    loop タスクの詳細化
        Task->>Task: タスクを更新
    end

    Task->>Exec: タスクを実行
    Exec-->>Dev: 実行結果
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

