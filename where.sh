#!/bin/bash

usage() {
    echo "where: find executables in PATH"
    echo "Usage: where [OPTIONS] COMMAND [COMMAND ...]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -a, --all           Show all occurrences (default behavior)"
    echo ""
    exit 1
}

# Check for help flag
if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Skip --all flag if present (it's default behavior)
if [[ "$1" == "-a" || "$1" == "--all" ]]; then
    shift
fi

found_any=0

# Process each command argument
for cmd in "$@"; do
    # Skip empty arguments
    [[ -z "$cmd" ]] && continue
    
    # If the command contains a slash, treat it as a path
    if [[ "$cmd" == */* ]]; then
        if [[ -x "$cmd" ]]; then
            echo "$cmd"
            ((found_any++))
        fi
    else
        # Search in PATH
        while IFS=: read -r dir; do
            [[ -z "$dir" ]] && dir="."
            if [[ -x "$dir/$cmd" ]]; then
                echo "$dir/$cmd"
                ((found_any++))
            fi
        done <<< "$PATH"
    fi
done

# Exit with error code if nothing found
if [[ $found_any -eq 0 ]]; then
    exit 1
fi

exit 0
