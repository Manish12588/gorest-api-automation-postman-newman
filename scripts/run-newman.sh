#!/usr/bin/env bash
# Runs a Newman collection, saves a timestamped HTML report, keeps a "latest" copy,
# and deletes old reports so only the last N remain.
#
# Usage:   scripts/run-newman.sh <collection.json> <report-name> [data.csv]
# Example: scripts/run-newman.sh collections/GoRestAPI-Workflow-v3.json workflow
#          scripts/run-newman.sh collections/DataDrivenAPIsCollection.json datadriven data/myuser.csv
#
# Optional environment variables:
#   ENV_FILE   environment file   (default: environments/GoRestEnv.json)
#   TOKEN_ID   value for tokenId  (overrides the environment file, used by Jenkins)
#   KEEP       reports to keep    (default: 5)

COLLECTION="$1"
NAME="$2"
DATA_FILE="${3:-}"
ENV_FILE="${ENV_FILE:-environments/GoRestEnv.json}"
KEEP="${KEEP:-5}"
REPORT_DIR="reports"

if [ -z "$COLLECTION" ] || [ -z "$NAME" ]; then
  echo "Usage: $0 <collection.json> <report-name> [data.csv]"
  exit 2
fi

mkdir -p "$REPORT_DIR"
REPORT="$REPORT_DIR/${NAME}-$(date +%Y%m%d%H%M%S).html"

# Build the Newman command
ARGS=(run "$COLLECTION" -e "$ENV_FILE" -r cli,htmlextra --reporter-htmlextra-export "$REPORT")
[ -n "$DATA_FILE" ] && ARGS+=(-d "$DATA_FILE")
[ -n "${TOKEN_ID:-}" ] && ARGS+=(--env-var "tokenId=$TOKEN_ID")

# Run Newman and remember its exit code (0 = all tests passed)
newman "${ARGS[@]}"
NEWMAN_EXIT=$?

# Copy this run to a fixed name so links and CI always point to the newest report
if [ -f "$REPORT" ]; then
  cp "$REPORT" "$REPORT_DIR/${NAME}-latest.html"
  echo "Report: $REPORT (also copied to $REPORT_DIR/${NAME}-latest.html)"
else
  echo "No report was generated."
fi

# Cleanup: keep only the newest $KEEP timestamped reports for this collection
ls -t "$REPORT_DIR/${NAME}"-[0-9]*.html 2>/dev/null | tail -n +$((KEEP + 1)) | while IFS= read -r old; do
  rm -f "$old"
done
echo "Kept the last $KEEP reports."

# Pass Newman's result on, so Jenkins marks the build red when a test fails
exit $NEWMAN_EXIT