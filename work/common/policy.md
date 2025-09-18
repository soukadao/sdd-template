# ポリシー

## テスト駆動開発(TDD)

### RED: 失敗するテストを書く

```ts
// src/feature/calculator/calculator.ts
export function add(a: number, b: number): number {}

// src/feature/calculator/indext.ts
export { add } from './calculator.js'

// src/feature/calculator/tests/calculator.test.ts
import { add } from '../index.js'

test("1+2=3", () => {
  expect(add(1, 2)).toBe(3);
});
```

## GREEN: テストを成功させる最低限のコードを書く

```ts
// src/feature/calculator/calculator.ts
export function add(a: number, b: number): number {
  return 3;
}
```

### REFACTOR: コードをリファクタリングしてきれいにする

```ts
// src/feature/calculator/calculator.ts
export function add(a: number, b: number): number {
  return a + b;
}
```

## リファクタリング

### 基本原則

#### 1. 小さなステップで進める

- 一度に大きな変更を行わず、小さな変更を積み重ねる
- 各ステップでテストを実行し、動作を確認する

#### 2. テストファーストの徹底

- リファクタリング前に包括的なテストを用意
- 各変更後にテストを実行して回帰を防ぐ

#### 3. 適切なタイミング

- 機能追加前のコード整理
- バグ修正時の構造改善
- コードレビュー時の品質向上

### リファクタリング技法

#### メソッドの整理

- メソッドの抽出（Extract Method）
- メソッドのインライン化
- 一時変数の削除
- パラメータの整理

#### クラス設計の改善

- クラスの抽出（Extract Class）
- 継承からコンポジションへの変更
- インターフェースの抽出
- 重複コードの排除

#### データ構造の改善

- フィールドのカプセル化
- データクラスの分割
- 配列からオブジェクトへの変換

### リファクタリングプロセス

1. 問題の特定 - コードの臭い（Code Smell）を見つける
2. テストの準備 - 既存機能をカバーする自動テストを作成
3. 小さな変更 - 一つずつ段階的に改善
4. テスト実行 - 各変更後に必ずテストを実行
5. コミット - 動作確認できた時点で変更をコミット