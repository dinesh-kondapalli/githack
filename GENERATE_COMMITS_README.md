# Generate Commits Guide

This guide explains how to use the `generate-commits.sh` script to properly generate git commits with backdated timestamps.

## Overview

The `generate-commits.sh` script automatically creates multiple git commits on a specified date with randomized timestamps throughout that day. This is useful for:
- Testing git workflows and history
- Demonstrating commit patterns
- Populating repositories with historical data
- Educational purposes

## Installation & Setup

1. **Make the script executable** (if not already):
   ```bash
   chmod +x generate-commits.sh
   ```

2. **Verify you're in a git repository**:
   ```bash
   git status
   ```

## Basic Usage

### Simple Syntax
```bash
./generate-commits.sh <date> [total_commits] [branch]
```

### Required Parameters
- **`<date>`**: The target date in `YYYY-MM-DD` format (e.g., `2024-01-15`)

### Optional Parameters
- **`[total_commits]`**: Number of commits to generate (default: `10`)
- **`[branch]`**: Branch name to create commits on (default: `main`)

## Usage Examples

### Example 1: Basic Usage
Generate 10 commits on January 15, 2024:
```bash
./generate-commits.sh 2024-01-15
```

### Example 2: Custom Commit Count
Generate 50 commits on December 1, 2023:
```bash
./generate-commits.sh 2023-12-01 50
```

### Example 3: Custom Branch
Generate 25 commits on a feature branch:
```bash
./generate-commits.sh 2024-02-20 25 feature/my-feature
```

### Example 4: Maximum Detail
Generate 100 commits on June 10, 2024 on branch `release/v2.0`:
```bash
./generate-commits.sh 2024-06-10 100 release/v2.0
```

## How It Works

### 1. Input Validation
- ✅ Checks that a date is provided
- ✅ Validates the date is in correct `YYYY-MM-DD` format
- ✅ Verifies the current directory is a git repository

### 2. Timestamp Generation
- Creates commits spread evenly throughout the entire 24-hour period
- Generates random timestamps between 00:00:00 and 23:59:59 on the target date
- Maintains chronological order of commits

### 3. Branch Management
- Creates a new branch with the specified name
- Switches to that branch
- Commits are isolated to this branch (doesn't affect main/master)

### 4. Commit Creation
- Generates empty commits (no file changes)
- Each commit gets a random message from a pool of 20 realistic messages:
  - "update documentation"
  - "fix minor bug"
  - "add new feature"
  - "refactor code"
  - "improve performance"
  - "update dependencies"
  - "fix typo"
  - "add tests"
  - "cleanup code"
  - "update README"
  - "fix issue"
  - "add error handling"
  - "optimize query"
  - "update config"
  - "add logging"
  - "fix race condition"
  - "update API"
  - "add validation"
  - "remove unused code"
  - "update comments"

### 5. Remote Push
- Automatically pushes the new branch to the remote repository
- Equivalent to: `git push origin <branch>`

## Important Warnings & Considerations

### ⚠️ Empty Commits
All generated commits are **empty** (contain no file changes). This is intentional and may be visible when:
- Reviewing commit history with `git show <commit>`
- Checking commit diffs
- Using tools that analyze file changes

### ⚠️ Automatic Push to Remote
The script **automatically pushes to the remote repository**. Be aware:
- A network connection is required
- Changes will be visible to all repository collaborators
- Ensure you have proper permissions on the remote

### ⚠️ Date Format is Strict
The date must be in **exact `YYYY-MM-DD` format**:
- ✅ `2024-01-15` (correct)
- ❌ `01/15/2024` (incorrect)
- ❌ `2024-1-15` (incorrect - needs leading zeros)
- ❌ `January 15, 2024` (incorrect)

### ⚠️ Branch Must Not Exist
The script uses `git checkout -b` which fails if the branch already exists:
- ❌ Won't overwrite existing branches
- ✅ Always use unique branch names
- If you need to regenerate, delete the branch first: `git branch -D <branch>`

### ⚠️ Platform Compatibility
The script requires:
- Linux/Unix environment or WSL (Windows Subsystem for Linux)
- GNU `date` command
- Standard bash shell
- May not work on macOS without additional tools (try `brew install coreutils`)

## Troubleshooting

### Error: "Not a git repository"
```
Solution: Run 'git init' or navigate to a git repository directory
```

### Error: "Date format is invalid"
```
Solution: Use YYYY-MM-DD format with leading zeros
Example: 2024-01-05 (not 2024-1-5)
```

### Error: "fatal: A branch named '<branch>' already exists"
```
Solution: Delete the existing branch first
$ git branch -D <branch-name>
$ ./generate-commits.sh <date> <count> <branch>
```

### Error: "Failed to push to remote"
```
Solution: Check your network connection and git credentials
$ git remote -v  (verify remote is configured)
$ ssh -T git@github.com  (test SSH connection if using SSH)
```

### Nothing happens / script seems slow
```
Solution: Large commit counts can take time
- For 100+ commits, the script may take several seconds
- Wait for the completion message to appear
- Check git log to verify commits were created:
  $ git log --oneline <branch-name>
```

## Best Practices

### 1. Use Descriptive Branch Names
```bash
# Good - clearly indicates purpose
./generate-commits.sh 2024-01-15 50 testing/jan-15-data

# Less clear
./generate-commits.sh 2024-01-15 50 test
```

### 2. Verify Before Pushing
If you want to review commits before pushing to remote, you can temporarily skip the push:
```bash
# Generate commits, then review
./generate-commits.sh 2024-01-15 25 temp/review

# Check the commits
git log --oneline temp/review -25

# Push if satisfied
git push origin temp/review

# Or delete if not satisfied
git branch -D temp/review
```

### 3. Document Your Generated Data
Keep track of what you generated:
```bash
# Add a note to your commit history
# git notes add -m "Generated 50 commits for testing on 2024-01-15"
```

### 4. Use Reasonable Commit Counts
- Small tests: 10-25 commits
- Medium tests: 25-100 commits
- Large tests: 100+ commits (may take longer)

### 5. Be Mindful of Repository Size
Each commit increases repository size slightly. Avoid generating thousands of commits unless necessary.

## Advanced Usage

### Batch Generate Multiple Days
```bash
#!/bin/bash
# Generate commits for 7 days
for i in {0..6}; do
  DATE=$(date -d "2024-01-01 +$i days" +%Y-%m-%d)
  ./generate-commits.sh "$DATE" 20 "history/jan-2024"
done
```

### Verify Generated Commits
```bash
# Count commits on a branch
git rev-list --count <branch-name>

# View commits with dates
git log --format="%h %ai %s" <branch-name>

# View commits in calendar view (requires git-cal or similar)
git log <branch-name> --graph --oneline --all
```

## Frequently Asked Questions

**Q: Can I generate commits with actual file changes?**
A: No, the script only creates empty commits. You would need to modify the script to add file changes.

**Q: Can I modify the commit messages?**
A: Yes, edit the `generate-commits.sh` script and modify the `messages` array.

**Q: Does this affect my main branch?**
A: No, commits are created on a separate branch. Your main/master branch is not affected.

**Q: Can I generate commits for past years?**
A: Yes, any date in `YYYY-MM-DD` format will work, including dates from 2000 or earlier.

**Q: What if I want to delete the generated commits?**
A: Simply delete the branch: `git branch -D <branch-name>`

**Q: Can I run this on a bare repository?**
A: No, you need a working directory with a checked-out branch.

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify your git installation: `git --version`
3. Test the date command: `date -d "2024-01-15" +%s`
4. Review the script comments: `cat generate-commits.sh`

---

**Last Updated**: April 2026  
**Version**: 1.0
