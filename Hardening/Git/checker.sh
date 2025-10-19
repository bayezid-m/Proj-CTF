#!/usr/bin/env bash
# verify_projectX.sh
# Checks git history for a hardcoded APIKEY and verifies that .env is listed in .gitignore
# Outputs in English.

set -u
# do not set -e because some commands intentionally return non-zero; handle errors manually

TARGET_API="APIKEY=12345asdf"
MAX_COMMITS_TO_SHOW=10

# Helper prints
info() { printf "%s\n" "$1"; }
error() { printf "ERROR: %s\n" "$1"; }
ok() { printf "OK: %s\n" "$1"; }

# Ensure we are inside a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  error "This directory is not a git repository. Run the script from the repository root."
  exit 2
fi

info "Checking git history for the literal string: ${TARGET_API}"

# Search all commits for occurrences of the literal string
# We'll collect commit hashes where the string appears in that commit's tree.
found_commits=()
# Use git rev-list to iterate safely
while IFS= read -r commit_hash; do
  # `git grep` returns non-zero when no match -> ignore that failure
  if git grep -F --line-number -- "${TARGET_API}" "${commit_hash}" -- >/dev/null 2>&1; then
    found_commits+=("$commit_hash")
  fi
done < <(git rev-list --all)

if [ "${#found_commits[@]}" -gt 0 ]; then
  error "API key string was found in the repository history."
  echo
  info "Commits where '${TARGET_API}' appears (showing up to ${MAX_COMMITS_TO_SHOW}):"
  count=0
  for c in "${found_commits[@]}"; do
    if [ "$count" -ge "$MAX_COMMITS_TO_SHOW" ]; then
      info "  ...and more (${#found_commits[@]} total matches)."
      break
    fi
    # show commit short id, author and subject for context
    git --no-pager show --quiet --format="  %h %an %ad %s" --date=short "$c"
    count=$((count + 1))
  done
  echo
  error "You must remove the secret from the repository history (e.g. use a safe history rewrite tool like git filter-repo) and force-push, or create a new repository. Soft resets alone do NOT remove the string from history."
  # continue to check gitignore as requested
  api_issue=1
else
  ok "API key string not found in repository history (no commit contains '${TARGET_API}')."
  api_issue=0
fi

echo
info "Checking .gitignore for '.env' entry"

if [ -f .gitignore ]; then
  if grep -Fxq ".env" .gitignore; then
    ok ".gitignore exists and contains '.env'."
    gitignore_ok=0
  else
    error ".gitignore exists but does NOT contain '.env'."
    gitignore_ok=1
  fi
else
  error ".gitignore file does not exist."
  gitignore_ok=1
fi

echo
# Final decision & messages in English
if [ "$api_issue" -eq 0 ] && [ "$gitignore_ok" -eq 0 ]; then
  # Both checks passed
  printf "FLAG: passed — repository history is clean (no '%s' found) and .env is ignored in .gitignore.\n" "${TARGET_API}"
  exit 0
else
  # One or both checks failed
  printf "PROBLEM: repository did not pass verification.\n"
  if [ "$api_issue" -ne 0 ]; then
    printf " - API key string '%s' found in history. Remove it from history (git filter-repo or BFG) and force-push, or recreate repo.\n" "${TARGET_API}"
  fi
  if [ "$gitignore_ok" -ne 0 ]; then
    printf " - .env is not ignored. Add a line with '.env' to .gitignore and commit the change, then ensure any committed .env is removed from history.\n"
  fi
  printf "Please try again after addressing the issues.\n"
  exit 3
fi
