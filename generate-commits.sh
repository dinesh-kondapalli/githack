#!/bin/bash

# Usage: ./generate-commits.sh <date> [total_commits] [branch]
# Example: ./generate-commits.sh 2024-01-15 50 main

# Parse arguments
target_date="${1:-}"
total_commits="${2:-10}"
branch="${3:-main}"

if [ -z "$target_date" ]; then
    echo "Usage: $0 <date> [total_commits] [branch]"
    echo "Example: $0 2024-01-15 50 main"
    exit 1
fi

# Validate date
if ! date -d "$target_date" &>/dev/null; then
    echo "Error: Invalid date format. Use YYYY-MM-DD"
    exit 1
fi

# Safety check: ensure we're in a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not a git repository!"
    exit 1
fi

# Get start of the target date in seconds
start_of_day=$(date -d "$target_date 00:00:00" +%s)

# Generate random offsets within the day (0 to 86399 seconds)
offsets=$(shuf -i 0-86399 -n "$total_commits" | sort -n)

# Create and switch to the target branch
git checkout -b "$branch"

# Array of realistic commit messages
messages=(
    "update documentation"
    "fix minor bug"
    "add new feature"
    "refactor code"
    "improve performance"
    "update dependencies"
    "fix typo"
    "add tests"
    "cleanup code"
    "update README"
    "fix issue"
    "add error handling"
    "optimize query"
    "update config"
    "add logging"
    "fix race condition"
    "update API"
    "add validation"
    "remove unused code"
    "update comments"
)

# Create commits with randomized times on the specified date
for offset in ${offsets}; do
    commit_time=$((start_of_day + offset))
    commit_date=$(date -d "@$commit_time" "+%Y-%m-%dT%H:%M:%S %:z")
    msg=${messages[$RANDOM % ${#messages[@]}]}
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit --allow-empty -m "$msg"
done

# Push to remote
git push origin "$branch"

echo "Done! Created $total_commits commits on $target_date on branch '$branch'"
