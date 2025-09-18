#!/usr/bin/env bash
# Create a new task file with template
# Usage: ./task-create.sh <feature-name>
#        ./task-create.sh --json <feature-name>

set -e

# Parse arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] <feature-name>"
            echo "Example: $0 user-authentication"
            echo "         $0 --json user-authentication"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
done

# Get feature name from remaining args
FEATURE_NAME="${ARGS[0]}"

if [ -z "$FEATURE_NAME" ]; then
    echo "Usage: $0 [--json] <feature-name>" >&2
    echo "Example: $0 user-authentication" >&2
    exit 1
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)

# Template path
TEMPLATE_PATH="$REPO_ROOT/package/template/task.md"

# Check if template exists
if [ ! -f "$TEMPLATE_PATH" ]; then
    if $JSON_MODE; then
        printf '{"error":"Template not found at %s"}\n' "$TEMPLATE_PATH" >&2
    else
        echo "Error: Template not found at $TEMPLATE_PATH" >&2
    fi
    exit 1
fi

# Find the highest numbered task file
HIGHEST=0
shopt -s nullglob
for file in "$REPO_ROOT"/[0-9][0-9][0-9]-*.md; do
    if [ -f "$file" ]; then
        basename=$(basename "$file")
        # Extract number from pattern like "001-feature.md"
        number=$(echo "$basename" | grep -o '^[0-9]\+' || echo "0")
        number=$((10#$number))
        if [ "$number" -gt "$HIGHEST" ]; then
            HIGHEST=$number
        fi
    fi
done
shopt -u nullglob

# Generate next task number with zero padding (3 digits)
NEXT=$((HIGHEST + 1))
TASK_NUM=$(printf "%03d" "$NEXT")

# Create task filename
TASK_FILENAME="${TASK_NUM}-${FEATURE_NAME}.md"
TASK_PATH="$REPO_ROOT/$TASK_FILENAME"

# Check if file already exists
if [ -f "$TASK_PATH" ]; then
    if $JSON_MODE; then
        printf '{"error":"File already exists at %s"}\n' "$TASK_PATH" >&2
    else
        echo "Error: File already exists at $TASK_PATH" >&2
    fi
    exit 1
fi

# Copy template to new task file
cp "$TEMPLATE_PATH" "$TASK_PATH"

# Output results
if $JSON_MODE; then
    printf '{"task_path":"%s","task_filename":"%s","task_number":"%s","feature_name":"%s"}\n' \
        "$TASK_PATH" "$TASK_FILENAME" "$TASK_NUM" "$FEATURE_NAME"
else
    echo "Created task file: $TASK_PATH"
    echo "Task number: $TASK_NUM"
    echo "Feature name: $FEATURE_NAME"
fi