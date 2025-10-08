#!/bin/bash
# spec_id.sh

echo "ワークフローを開始します..."

WORKFLOW_FILE_NAME="generate-spec-id.yml"

# 実行中またはキュー待ちのワークフローをチェック
RUNNING=$(gh run list --workflow "$WORKFLOW_FILE_NAME" --json status,conclusion -q '[.[] | select(.status == "in_progress" or .status == "queued" or .status == "waiting")] | length')

if [ "$RUNNING" -gt 0 ]; then
  echo "ワークフローは既に実行中またはキュー待ちです。完了するまでお待ちください。"
  exit 1
fi

# ワークフローを実行
gh workflow run generate-spec-id.yml

echo "ワークフローの開始を待っています..."
sleep 5

# 実行中のワークフローが複数ある場合は停止
RUNNING=$(gh run list --workflow "$WORKFLOW_FILE_NAME" --status in_progress --json databaseId -q 'length')
if [ "$RUNNING" -gt 1 ]; then
  echo "エラー: 複数のワークフローが実行中です。前のワークフローが完了してから再試行してください。"
  exit 1
fi

# 最新の実行を取得
LATEST_RUN=$(gh run list --workflow=generate-spec-id.yml --limit=1 --json databaseId,number,status -q '.[0]')
RUN_ID=$(echo $LATEST_RUN | jq -r '.databaseId')
RUN_NUMBER=$(echo $LATEST_RUN | jq -r '.number')

echo "生成されたSpec ID: $RUN_NUMBER"
echo "フォルダ名: spec-$RUN_NUMBER"

# フォルダを作成
mkdir -p ".project/works/spec-$RUN_NUMBER"
echo "フォルダを作成しました: .project/works/spec-$RUN_NUMBER"
