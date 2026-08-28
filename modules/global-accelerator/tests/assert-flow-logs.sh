#!/usr/bin/env bash
set -euo pipefail

module_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_file="$(mktemp)"
trap 'rm -f "$output_file"' EXIT

terraform -chdir="$module_dir" test -filter=tests/flow-logs.tftest.hcl -verbose -no-color >"$output_file"

grep -Eq 'flow_logs_enabled[[:space:]]*=[[:space:]]*true' "$output_file"
grep -Eq 'flow_logs_s3_bucket[[:space:]]*=[[:space:]]*"example-global-accelerator-flow-logs"' "$output_file"
grep -Eq 'flow_logs_s3_prefix[[:space:]]*=[[:space:]]*"global-accelerator"' "$output_file"
