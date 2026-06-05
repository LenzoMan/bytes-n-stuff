#!/bin/zsh
set -euo pipefail

MAIN_BRANCH="main"
PUBLISH_BRANCH="gh-pages"
WORKTREE_DIR="../_ghp_worktree"
SITE_DIR="public"
DOMAIN_FILE_CONTENT="lenmahlangu.online"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	echo "ERROR: run this script from inside the repository." >&2
	exit 1
fi

echo "==> Ensuring on $MAIN_BRANCH"
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "$MAIN_BRANCH" ]]; then
	echo "Switching from $current_branch to $MAIN_BRANCH"
	git checkout "$MAIN_BRANCH"
fi

echo "==> Checking for uncommitted source changes"
if ! git diff --quiet || ! git diff --cached --quiet; then
	echo "ERROR: Working tree is dirty. Commit or stash changes before deploy." >&2
	exit 2
fi

echo "==> Pulling latest $MAIN_BRANCH"
git pull --ff-only origin "$MAIN_BRANCH"

echo "==> Building site with Hugo"
hugo
if [[ ! -d "$SITE_DIR" ]]; then
	echo "ERROR: Build output directory '$SITE_DIR' not found." >&2
	exit 3
fi

echo "==> Preparing worktree for $PUBLISH_BRANCH at $WORKTREE_DIR"
if [[ -d "$WORKTREE_DIR" ]]; then
	git worktree remove -f "$WORKTREE_DIR" 2>/dev/null || rm -rf "$WORKTREE_DIR"
fi
git worktree prune

if git ls-remote --exit-code --heads origin "$PUBLISH_BRANCH" >/dev/null 2>&1; then
	git worktree add -B "$PUBLISH_BRANCH" "$WORKTREE_DIR" "origin/$PUBLISH_BRANCH"
else
	git worktree add -B "$PUBLISH_BRANCH" "$WORKTREE_DIR" "$MAIN_BRANCH"
fi

if [[ ! -e "$WORKTREE_DIR/.git" ]]; then
	echo "ERROR: Failed to initialize publish worktree." >&2
	exit 4
fi

echo "==> Cleaning publish worktree"
find "$WORKTREE_DIR" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +

echo "==> Syncing $SITE_DIR to publish worktree"
rsync -a --delete --exclude='.git' "$SITE_DIR"/ "$WORKTREE_DIR"/

echo "==> Ensuring CNAME and .nojekyll"
echo "$DOMAIN_FILE_CONTENT" > "$WORKTREE_DIR/CNAME"
touch "$WORKTREE_DIR/.nojekyll"

pushd "$WORKTREE_DIR" >/dev/null
echo "==> Preparing commit on $PUBLISH_BRANCH"
current_publish_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_publish_branch" != "$PUBLISH_BRANCH" ]]; then
	echo "ERROR: Expected worktree on '$PUBLISH_BRANCH' but found '$current_publish_branch'." >&2
	exit 5
fi
git add -A

if git diff --cached --quiet; then
	echo "No changes to publish."
else
	git commit --no-verify -m "deploy: publish site $(date '+%Y-%m-%d %H:%M:%S')"
	echo "==> Pushing $PUBLISH_BRANCH"
	git push origin "$PUBLISH_BRANCH"
fi
popd >/dev/null

echo "==> Cleaning up worktree"
rm -rf "$WORKTREE_DIR"

echo "==> Done. Live site: https://$DOMAIN_FILE_CONTENT/"
