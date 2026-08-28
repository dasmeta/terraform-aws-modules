#!/usr/bin/env bash
set -euo pipefail

module_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$(mktemp -d)"
default_output_file="$output_dir/default-flow-logs.txt"
enabled_output_file="$output_dir/enabled-flow-logs.txt"
contract_output_file="$output_dir/contract.txt"
accelerator_block_file="$output_dir/nondefault-accelerator.txt"
trap 'rm -rf "$output_dir"' EXIT

terraform -chdir="$module_dir" test -filter=tests/basic.tftest.hcl -verbose -no-color >"$default_output_file"
terraform -chdir="$module_dir" test -filter=tests/flow-logs.tftest.hcl -verbose -no-color >"$enabled_output_file"
terraform -chdir="$module_dir" test -filter=tests/contract.tftest.hcl -verbose -no-color >"$contract_output_file"

if grep -Eq 'flow_logs_(enabled|s3_bucket|s3_prefix)[[:space:]]*=' "$default_output_file"; then
  echo "Default accelerator plan unexpectedly contains an upstream flow-log attributes block." >&2
  exit 1
fi

grep -Eq 'flow_logs_enabled[[:space:]]*=[[:space:]]*true' "$enabled_output_file"
grep -Eq 'flow_logs_s3_bucket[[:space:]]*=[[:space:]]*"example-global-accelerator-flow-logs"' "$enabled_output_file"
grep -Eq 'flow_logs_s3_prefix[[:space:]]*=[[:space:]]*"global-accelerator"' "$enabled_output_file"

awk '
  /resource "aws_globalaccelerator_accelerator" "this" \{/ {
    capture = 1
    block = ""
    depth = 0
  }

  capture {
    block = block $0 ORS

    line = $0
    opening_braces = gsub(/\{/, "{", line)
    line = $0
    closing_braces = gsub(/\}/, "}", line)
    depth += opening_braces - closing_braces

    if (depth == 0) {
      if (block ~ /name[[:space:]]*=[[:space:]]*"contract-nondefault-accelerator"/) {
        printf "%s", block
      }
      capture = 0
    }
  }
' "$contract_output_file" >"$accelerator_block_file"

if [[ ! -s "$accelerator_block_file" ]]; then
  echo "Could not find the uniquely named non-default upstream accelerator plan." >&2
  exit 1
fi

assert_accelerator_value() {
  local pattern="$1"
  local description="$2"

  if ! grep -Eq "$pattern" "$accelerator_block_file"; then
    echo "Non-default upstream accelerator plan is missing the exact $description." >&2
    exit 1
  fi
}

assert_accelerator_value '^[[:space:]]*([+][[:space:]]*)?name[[:space:]]*=[[:space:]]*"contract-nondefault-accelerator"[[:space:]]*$' 'name'
assert_accelerator_value '^[[:space:]]*([+][[:space:]]*)?enabled[[:space:]]*=[[:space:]]*false[[:space:]]*$' 'enabled value'
assert_accelerator_value '^[[:space:]]*([+][[:space:]]*)?ip_address_type[[:space:]]*=[[:space:]]*"DUAL_STACK"[[:space:]]*$' 'IP address type'
assert_accelerator_value '^[[:space:]]*([+][[:space:]]*)?"?ContractBoundary"?[[:space:]]*=[[:space:]]*"top-level-accelerator-wiring"[[:space:]]*$' 'ContractBoundary tag'
assert_accelerator_value '^[[:space:]]*([+][[:space:]]*)?"?TestScope"?[[:space:]]*=[[:space:]]*"global-accelerator"[[:space:]]*$' 'TestScope tag'
