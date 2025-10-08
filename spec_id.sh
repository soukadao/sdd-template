#!/bin/bash
# spec_id.sh

WORKFLOW_FILE_NAME="generate-spec-id.yml"

echo "ワークフローを開始します..."

# ワークフロー実行前の最新run_numberを記録
BEFORE_RUN_NUMBER=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=1 --json number -q '.[0].number // 0')

# ワークフローを実行
gh workflow run "$WORKFLOW_FILE_NAME"

echo "ワークフローの完了を待っています..."

# 新しいワークフローが完了するまで待機（最大120秒）
MAX_WAIT=120
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
  sleep 3
  ELAPSED=$((ELAPSED + 3))

  # BEFORE_RUN_NUMBERより大きい番号で、完了したものを探す
  COMPLETED_RUN=$(gh run list --workflow="$WORKFLOW_FILE_NAME" --limit=10 --json number,status,conclusion,createdAt | \
    jq -r --arg before "$BEFORE_RUN_NUMBER" '
      [.[] | select(.number > ($before | tonumber) and .status == "completed")]
      | sort_by(.createdAt)
      | .[0]
      | select(. != null)
    ')

  if [ -n "$COMPLETED_RUN" ]; then
    RUN_NUMBER=$(echo "$COMPLETED_RUN" | jq -r '.number')
    CONCLUSION=$(echo "$COMPLETED_RUN" | jq -r '.conclusion')

    if [ "$CONCLUSION" != "success" ]; then
      echo "エラー: ワークフローが失敗しました (conclusion: $CONCLUSION)"
      exit 1
    fi

    echo "生成されたSpec ID: $RUN_NUMBER"
    echo "フォルダ名: spec-$RUN_NUMBER"

    # フォルダを作成
    mkdir -p ".project/works/spec-$RUN_NUMBER"
    echo "フォルダを作成しました: .project/works/spec-$RUN_NUMBER"

    # ロックは自動的に解放される
    exit 0
  fi
done

echo "エラー: ${MAX_WAIT}秒待機しましたが、ワークフローの完了を確認できませんでした。"
exit 1
