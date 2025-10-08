#!/bin/bash
# spec_id.sh

WORKFLOW_FILE_NAME="generate-spec-id.yml"

# 実行中またはキュー待ちのワークフローをチェック
RUNNING=$(gh run list --workflow "$WORKFLOW_FILE_NAME" --json status -q '[.[] | select(.status == "in_progress" or .status == "queued" or .status == "waiting")] | length')

if [ "$RUNNING" -gt 0 ]; then
  echo "ワークフローは既に実行中またはキュー待ちです。完了するまでお待ちください。"
  exit 1
fi

echo "ワークフローを開始します..."

# ワークフロー実行前の最新run_numberを記録
BEFORE_RUN_NUMBER=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=1 --json number -q '.[0].number // 0')

# ワークフローを実行
gh workflow run "$WORKFLOW_FILE_NAME"

echo "ワークフローの開始を待っています..."

# 新しいワークフローが開始されるまで待機（最大30秒）
MAX_WAIT=30
ELAPSED=0
while [ $ELAPSED -lt $MAX_WAIT ]; do
  sleep 2
  ELAPSED=$((ELAPSED + 2))

  LATEST_RUN=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=1 --json databaseId,number,status -q '.[0]')
  CURRENT_RUN_NUMBER=$(echo "$LATEST_RUN" | jq -r '.number // 0')

  # 新しいワークフローが検出されたか確認
  if [ "$CURRENT_RUN_NUMBER" -gt "$BEFORE_RUN_NUMBER" ]; then
    RUN_ID=$(echo "$LATEST_RUN" | jq -r '.databaseId')
    RUN_NUMBER=$CURRENT_RUN_NUMBER

    echo "生成されたSpec ID: $RUN_NUMBER"
    echo "フォルダ名: spec-$RUN_NUMBER"

    # フォルダを作成
    mkdir -p ".project/works/spec-$RUN_NUMBER"
    echo "フォルダを作成しました: .project/works/spec-$RUN_NUMBER"

    exit 0
  fi
done

echo "エラー: ${MAX_WAIT}秒待機しましたが、ワークフローの開始を確認できませんでした。"
exit 1
