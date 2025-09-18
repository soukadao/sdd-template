#!/usr/bin/env bash
# Create a new phase directory with proper structure
# Usage: ./init.sh
#        ./init.sh --json

set -e

JSON_MODE=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json]"; exit 0 ;;
    esac
done

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
WORK_DIR="$REPO_ROOT/.spec/work"

# Create work directory if it doesn't exist
mkdir -p "$WORK_DIR"

# Find the highest numbered phase directory
HIGHEST=0
if [ -d "$WORK_DIR" ]; then
    for dir in "$WORK_DIR"/phase-*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            number=$(echo "$dirname" | sed 's/phase-//' | sed 's/^0*//')
            if [ -z "$number" ]; then
                number=0
            fi
            if [ "$number" -gt "$HIGHEST" ]; then
                HIGHEST=$number
            fi
        fi
    done
fi

# Generate next phase number with zero padding (5 digits)
NEXT=$((HIGHEST + 1))
PHASE_NUM=$(printf "%05d" "$NEXT")
PHASE_NAME="phase-${PHASE_NUM}"

# Create phase directory
PHASE_DIR="$WORK_DIR/$PHASE_NAME"
mkdir -p "$PHASE_DIR"

# Copy requirements.md template
REQUIREMENTS_TEMPLATE="$REPO_ROOT/.spec/template/requirements.md"
REQUIREMENTS_FILE="$PHASE_DIR/requirements.md"

cp "$REQUIREMENTS_TEMPLATE" "$REQUIREMENTS_FILE"

if $JSON_MODE; then
    printf '{"PHASE_NAME":"%s","PHASE_DIR":"%s","PHASE_NUM":"%s"}\n' \
        "$PHASE_NAME" "$PHASE_DIR" "$PHASE_NUM"
else
    # Output results
    echo "PHASE_NAME: $PHASE_NAME"
    echo "PHASE_DIR: $PHASE_DIR"
    echo "PHASE_NUM: $PHASE_NUM"
fi