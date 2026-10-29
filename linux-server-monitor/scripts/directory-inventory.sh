
#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/devops-lab}"
REPORT_DIR="${2:-./reports}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "ERROR: Directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

mkdir -p "$REPORT_DIR"

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
REPORT_DIR="$(cd "$REPORT_DIR" && pwd)"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_FILE="$REPORT_DIR/inventory_$TIMESTAMP.txt"

{
  echo "================================="
  echo "       LINUX DIRECTORY REPORT"
  echo "================================="
  echo "Date: $(date)"
  echo "Hostname: $(hostname)"
  echo "Target: $TARGET_DIR"
  echo

  echo "FILES:"
  find "$TARGET_DIR" -type f | wc -l
  echo

  echo "DIRECTORIES:"
  find "$TARGET_DIR" -type d | wc -l
  echo

  echo "DISK USAGE:"
  du -sh "$TARGET_DIR"
  echo

  echo "TOP 5 LARGEST FILES:"
  find "$TARGET_DIR" -type f -exec stat -f '%z %N' {} + |
    sort -nr |
    head -5
  echo

  echo "LOG FILES:"
  find "$TARGET_DIR" -type f -name "*.log"
  echo

  echo "REPORT COMPLETE"
} > "$REPORT_FILE"

echo "Report saved to: $REPORT_FILE"

