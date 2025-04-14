#!/bin/bash

# Usage: ./collect_help.sh <command> <output_file>
# Example: ./collect_help.sh ros2 ros2_help.txt

COMMAND=$1
OUTPUT_FILE=$2

# Ensure output file is empty
> "$OUTPUT_FILE"

# Track processed commands to prevent loops
declare -A processed

# Function to collect help recursively
collect_help() {
    local cmd="$1"
    local indent="$2"
    local depth="${3:-0}"

    # Prevent infinite recursion (depth limit)
    if [ "$depth" -gt 10 ]; then
        echo "${indent}[Depth limit reached for $cmd]" >> "$OUTPUT_FILE"
        return
    fi

    # Skip if already processed
    if [[ -n "${processed["$cmd"]}" ]]; then
        return
    fi

    # Mark command as processed
    processed["$cmd"]=1

    # Run help command and capture output
    echo "${indent}${cmd} --help" >> "$OUTPUT_FILE"
    echo "${indent}----------------------------------------" >> "$OUTPUT_FILE"
    $cmd --help >> "$OUTPUT_FILE" 2>&1
    echo -e "${indent}----------------------------------------\n" >> "$OUTPUT_FILE"

    # Extract subcommands from the "Commands:" section
    # Use awk to capture commands after "Commands:" until an empty line or unrelated content
    subcommands=$($cmd --help 2>&1 | awk '/^Commands:/{flag=1; next} flag && /^[[:space:]]+[a-zA-Z0-9_-]+[[:space:]]/{print $1} /^[^[:space:]]/{flag=0}' | sort -u)

    # Process each subcommand
    for subcmd in $subcommands; do
        # Skip options (starting with '-')
        [[ "$subcmd" =~ ^- ]] && continue

        # Check if subcommand supports --help
        if $cmd "$subcmd" --help >/dev/null 2>&1; then
            collect_help "$cmd $subcmd" "  $indent" "$((depth + 1))"
        fi
    done
}

# Start the process
collect_help "$COMMAND" "" 0

echo "Help output saved to $OUTPUT_FILE"