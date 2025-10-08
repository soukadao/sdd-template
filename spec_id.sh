#!/bin/bash
# spec_id.sh

WORKFLOW_FILE_NAME="generate-spec-id.yml"

# 一意なリクエストIDを生成（タイムスタンプ + ランダム値）
REQUEST_ID="req-$(date +%s)-$$-$RANDOM"

echo "ワークフローを開始します... (Request ID: $REQUEST_ID)"

# リクエストIDを渡してワークフローを実行
gh workflow run "$WORKFLOW_FILE_NAME" -f request_id="$REQUEST_ID"

echo "自分のワークフローを特定しています..."

# 自分のワークフローが出現するまで待機（最大30秒）
MY_RUN_NUMBER=""
for i in {1..15}; do
  sleep 2

  # 最新のワークフローを取得してログを確認
  RECENT_RUNS=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=5 --json databaseId,number,status)

  # 各ワークフローのログから自分のREQUEST_IDを探す
  for run_id in $(echo "$RECENT_RUNS" | jq -r '.[].databaseId'); do
    # ログを取得してREQUEST_IDが含まれているか確認
    LOG_CONTENT=$(gh run view "$run_id" --log 2>/dev/null | grep -F "Request ID: $REQUEST_ID" || true)

    if [ -n "$LOG_CONTENT" ]; then
      # 自分のワークフローを見つけた
      MY_RUN_NUMBER=$(echo "$RECENT_RUNS" | jq -r --arg id "$run_id" '.[] | select(.databaseId == ($id | tonumber)) | .number')
      echo "自分のワークフローを特定しました: run_number=$MY_RUN_NUMBER"
      break 2
    fi
  done
done

if [ -z "$MY_RUN_NUMBER" ]; then
  echo "エラー: 自分のワークフローを特定できませんでした。"
  exit 1
fi

echo "ワークフローの完了を待っています..."

# 自分のワークフローが完了するまで待機（最大120秒）
MAX_WAIT=120
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
  sleep 3
  ELAPSED=$((ELAPSED + 3))

  # 自分のワークフローの状態を確認
  MY_RUN_STATUS=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=10 --json number,status,conclusion | \
    jq -r --arg my_number "$MY_RUN_NUMBER" '
      .[] | select(.number == ($my_number | tonumber))
    ')

  if [ -n "$MY_RUN_STATUS" ]; then
    STATUS=$(echo "$MY_RUN_STATUS" | jq -r '.status')
    CONCLUSION=$(echo "$MY_RUN_STATUS" | jq -r '.conclusion')

    if [ "$STATUS" = "completed" ]; then
      if [ "$CONCLUSION" != "success" ]; then
        echo "エラー: ワークフローが失敗しました (conclusion: $CONCLUSION)"
        exit 1
      fi

      echo "生成されたSpec ID: $MY_RUN_NUMBER"
      echo "フォルダ名: spec-$MY_RUN_NUMBER"

      # フォルダを作成
      mkdir -p ".project/works/spec-$MY_RUN_NUMBER"
      echo "フォルダを作成しました: .project/works/spec-$MY_RUN_NUMBER"

      exit 0
    fi
  fi
done

echo "エラー: ${MAX_WAIT}秒待機しましたが、ワークフローの完了を確認できませんでした。"
exit 1
