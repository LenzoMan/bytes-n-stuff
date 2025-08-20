#!/bin/zsh
set -euo pipefail

### Configuration ###
MAIN_BRANCH="main"
PUBLISH_BRANCH="gh-pages"
WORKTREE_DIR="../_ghp_worktree"
SITE_DIR="public"
DOMAIN_FILE_CONTENT="lenmahlangu.online"

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

echo "==> Preparing worktree for $PUBLISH_BRANCH at $WORKTREE_DIR"
rm -rf "$WORKTREE_DIR"
git worktree add -B "$PUBLISH_BRANCH" "$WORKTREE_DIR" "origin/$PUBLISH_BRANCH" 2>/dev/null || \
git worktree add -B "$PUBLISH_BRANCH" "$WORKTREE_DIR" "$PUBLISH_BRANCH"

echo "==> Syncing $SITE_DIR -> worktree"
rsync -a --delete "$SITE_DIR"/ "$WORKTREE_DIR"/

echo "==> Ensuring CNAME and .nojekyll"
echo "$DOMAIN_FILE_CONTENT" > "$WORKTREE_DIR/CNAME"
if [[ ! -f "$WORKTREE_DIR/.nojekyll" ]]; then
	touch "$WORKTREE_DIR/.nojekyll"
fi

echo "==> Committing publish branch (if changes)"
pushd "$WORKTREE_DIR" >/dev/null
git add .
if git diff --cached --quiet; then
	echo "No site changes to publish."
else
	git commit -m "deploy: publish updated site"
	echo "==> Pushing $PUBLISH_BRANCH"
	git push origin "$PUBLISH_BRANCH"
fi
popd >/dev/null

echo "==> Done. Preview: https://$DOMAIN_FILE_CONTENT/"
