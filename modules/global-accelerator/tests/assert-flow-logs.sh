#!/usr/bin/env bash
set -euo pipefail

module_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$(mktemp -d)"
default_output_file="$output_dir/default-flow-logs.txt"
enabled_output_file="$output_dir/enabled-flow-logs.txt"
trap 'rm -rf "$output_dir"' EXIT

terraform -chdir="$module_dir" test -filter=tests/contract.tftest.hcl -verbose -no-color >"$default_output_file"
terraform -chdir="$module_dir" test -filter=tests/flow-logs.tftest.hcl -verbose -no-color >"$enabled_output_file"

if grep -Eq 'flow_logs_(enabled|s3_bucket|s3_prefix)[[:space:]]*=' "$default_output_file"; then
  echo "Default accelerator plan unexpectedly contains an upstream flow-log attributes block." >&2
  exit 1
fi

grep -Eq 'flow_logs_enabled[[:space:]]*=[[:space:]]*true' "$enabled_output_file"
grep -Eq 'flow_logs_s3_bucket[[:space:]]*=[[:space:]]*"example-global-accelerator-flow-logs"' "$enabled_output_file"
grep -Eq 'flow_logs_s3_prefix[[:space:]]*=[[:space:]]*"global-accelerator"' "$enabled_output_file"
