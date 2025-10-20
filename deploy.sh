#!/bin/zsh
set -euo pipefail

### Configuration ###
MAIN_BRANCH="main"
PUBLISH_BRANCH="gh-pages"
WORKTREE_DIR="./_ghp_worktree"
SITE_DIR="public"
DOMAIN_FILE_CONTENT="lenmahlangu.online"
ALLOWED_SOURCE_ROOT="$(pwd)"

echo "==> Ensuring on $MAIN_BRANCH branch"
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "$MAIN_BRANCH" ]]; then
	echo "Switching from $current_branch to $MAIN_BRANCH"
	git checkout "$MAIN_BRANCH"
fi

echo "==> Pull latest $MAIN_BRANCH"
git pull --ff-only origin "$MAIN_BRANCH" || git pull origin "$MAIN_BRANCH"

echo "==> Staging source changes (excluding $SITE_DIR)"
git add .
if git diff --cached --quiet; then
	echo "No source changes to commit."
else
	git commit -m "chore: source update before publish"
fi

echo "==> Building site with Hugo"
hugo

if [[ ! -d "$SITE_DIR" ]]; then
	echo "ERROR: build output directory '$SITE_DIR' not found" >&2
	exit 1
fi

echo "==> Preparing clean worktree for $PUBLISH_BRANCH at $WORKTREE_DIR"
# Remove existing worktree if it exists
if [[ -d "$WORKTREE_DIR" ]]; then
    git worktree remove -f "$WORKTREE_DIR" 2>/dev/null || rm -rf "$WORKTREE_DIR"
fi

# Prune any stale worktree references
git worktree prune

# Ensure parent directory exists
mkdir -p "$(dirname "$WORKTREE_DIR")"

# Create new worktree
if git ls-remote --exit-code origin "$PUBLISH_BRANCH" >/dev/null 2>&1; then
    git worktree add --force -B "$PUBLISH_BRANCH" "$WORKTREE_DIR" "origin/$PUBLISH_BRANCH"
else
    git worktree add --force -B "$PUBLISH_BRANCH" "$WORKTREE_DIR"
fi

# Verify worktree setup
echo "==> Verifying worktree setup"
if [[ ! -f "$WORKTREE_DIR/.git" ]]; then
    echo "Waiting for Git worktree setup..."
    sleep 2  # Give Git a moment to complete setup
fi

if [[ ! -f "$WORKTREE_DIR/.git" ]]; then
    echo "ERROR: Failed to properly initialize git worktree" >&2
    exit 4
fi

# Give Git a moment to set up the worktree
sleep 1

echo "==> Wiping existing files in publish worktree (keeping .git)"
# Extra safety check for worktree path
if [[ ! -f "$WORKTREE_DIR/.git" ]]; then
    echo "ERROR: Worktree directory does not appear to be a git worktree" >&2
    exit 4
fi
find "$WORKTREE_DIR" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +

echo "==> Syncing $SITE_DIR -> worktree (only repo content)"
rsync -a --delete --no-links --safe-links "$SITE_DIR"/ "$WORKTREE_DIR"/

echo "==> Ensuring CNAME and .nojekyll"
echo "$DOMAIN_FILE_CONTENT" > "$WORKTREE_DIR/CNAME"
if [[ ! -f "$WORKTREE_DIR/.nojekyll" ]]; then
	touch "$WORKTREE_DIR/.nojekyll"
fi

echo "==> Committing publish branch (if changes)"
pushd "$WORKTREE_DIR" >/dev/null

# Safety: ensure we are in the intended worktree path and not capturing parent filesystem
WT_ROOT="$(pwd)"
if [[ "$WT_ROOT" != *"_ghp_worktree" ]]; then
	echo "ERROR: Unexpected worktree path $WT_ROOT" >&2
	exit 2
fi

git add -A
if git diff --cached --quiet; then
	echo "No site changes to publish."
else
	# Final guard: ensure no paths outside (should not occur after wipe & rsync)
	if git diff --cached --name-only | grep -E '^\.\./' >/dev/null; then
		echo "ERROR: Detected paths escaping worktree. Aborting publish." >&2
		exit 3
	fi
	git commit -m "deploy: publish updated site"
	echo "==> Pushing $PUBLISH_BRANCH"
	git push origin "$PUBLISH_BRANCH"
fi
popd >/dev/null

echo "==> Done. Preview: https://$DOMAIN_FILE_CONTENT/"
