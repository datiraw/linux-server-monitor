
#!/usr/bin/env bash
set -euo pipefail

# Default directories
TARGET_DIR="${1:-$HOME/devops-lab}"
REPORT_DIR="${2:-./reports}"

# 1. Validate target directory
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "ERROR: Target directory does not exist: $TARGET_DIR" >&2
  echo "Please provide a valid directory path." >&2
  echo "Example: ./inventory.sh ~/devops-lab" >&2
  exit 1
fi

# Create report directory
mkdir -p "$REPORT_DIR"

# Convert paths to absolute paths
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
REPORT_DIR="$(cd "$REPORT_DIR" && pwd)"

# Generate report filename
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_FILE="$REPORT_DIR/inventory_$TIMESTAMP.txt"

# Generate inventory report
{
  echo "================================="
  echo "       LINUX DIRECTORY REPORT"
  echo "================================="
  echo "Date: $(date)"
  echo "Hostname: $(hostname)"

  # 2. Display current username
  echo "Username: $(whoami)"

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

  # 3. Display top 10 largest files
  echo "TOP 10 LARGEST FILES (BYTES):"
  find "$TARGET_DIR" -type f -exec stat -f '%z %N' {} + |
    sort -nr |
    sed -n '1,10p'
  echo

  # 4. Files modified within last 24 hours
  echo "FILES MODIFIED IN THE LAST 24 HOURS:"
  find "$TARGET_DIR" -type f -mtime -1
  echo

  # 5. Available filesystem space
  echo "AVAILABLE FILESYSTEM SPACE:"
  df -h "$TARGET_DIR"
  echo

  echo "LOG FILES:"
  find "$TARGET_DIR" -type f -name "*.log"
  echo

  echo "REPORT COMPLETE"

} > "$REPORT_FILE"

echo "Report saved to: $REPORT_FILE"

