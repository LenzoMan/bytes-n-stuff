# My Blogsite

Personal blog built with [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) and deployed via a separate **`gh-pages`** branch using a Git worktree.

## Prerequisites

- [Hugo](https://gohugo.io/getting-started/installing/) installed (extended version recommended)
- [Git](https://git-scm.com/)

## Running the Site Locally

1. Open a terminal and navigate to the project root:

   ```sh
   cd my-blogsite
   ```

2. Start the Hugo development server:

   ```sh
   hugo serve
   ```

3. Visit [http://localhost:1313](http://localhost:1313) in your browser to preview the site.

## Building the Site for Production

1. From the project root, run:

   ```sh
   hugo
   ```

2. The static site will be generated in the `public/` directory.

## Updating Content

- Add new posts in `content/posts/` using Markdown files.
- To publish a post, set `draft: false` in its front matter. Posts with `draft: true` will not appear on the live site.
- To mark a post as archived, add `archive: true` to its front matter (optional for custom handling).
- The site is built with `buildDrafts: false`, so only published posts (`draft: false`) appear on the live site.

## Deploying (Automated Worktree Flow)

Deployment uses a dedicated `gh-pages` branch that contains **only the built site**. The source (content, config, theme) lives on `main`. The site is served from the custom domain `lenmahlangu.online` via GitHub Pages.

Run the deploy script from the project root:

```sh
./deploy.sh
```

What it does:

1. Ensures you are on `main` and pulls latest.
2. Commits any source changes (if there are staged differences).
3. Runs `hugo` to (re)generate `public/`.
4. Creates / refreshes a worktree at `../_ghp_worktree` pointing at `gh-pages`.
5. Wipes existing files in that worktree (except its `.git`).
6. Copies the contents of `public/` into the worktree.
7. Ensures `CNAME` (custom domain) and `.nojekyll` exist.
8. Commits & pushes to `gh-pages` only if there are changes.

**Custom Domain Setup:**

- The `CNAME` file is stored in `static/CNAME` and automatically included in Hugo builds.
- GitHub Pages is configured to use the `gh-pages` branch as the source.
- The custom domain must be verified in GitHub repository **Settings > Pages**.

The live site is served at `https://lenmahlangu.online/` from the `gh-pages` branch.

## Manual Deployment (Fallback)

Only needed if the script fails and you want to push manually.

```sh
# From main branch
hugo

# Recreate worktree
rm -rf ../_ghp_worktree
git worktree add -B gh-pages ../_ghp_worktree origin/gh-pages

# Sync build output
rsync -a --delete public/ ../_ghp_worktree/
echo "lenmahlangu.online" > ../_ghp_worktree/CNAME
touch ../_ghp_worktree/.nojekyll

# Commit and push
cd ../_ghp_worktree
git add -A
git commit -m "deploy: manual publish" || echo "No changes"
git push origin gh-pages
cd -
```

## Cleaning Up

- Do **not** edit `public/` manually; regenerate via `hugo`.
- Never edit files inside the worktree path (`../_ghp_worktree`) directly—let the script manage it.
- If a worktree gets stuck, remove it: `rm -rf ../_ghp_worktree && git worktree prune`.

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| Post not appearing on live site | Post marked as `draft: true` | Set `draft: false` in front matter, rebuild, and redeploy |
| New post 404s | Not yet published to `gh-pages` | Run `./deploy.sh` and wait 1–2 min for GitHub Pages to rebuild |
| Site shows 404 at custom domain | GitHub Pages not configured for custom domain | Verify DNS records and GitHub **Settings > Pages** has custom domain set |
| Custom domain lost | Missing `CNAME` in `gh-pages` | Ensure `static/CNAME` exists with domain name, rebuild, and redeploy |
| `fatal: 'gh-pages' is already used by worktree` | Stale worktree dir | `rm -rf ../_ghp_worktree && git worktree prune` then redeploy |
| Nothing to publish | No changes detected in `public/` | Make content edits or force rebuild with `hugo`, then redeploy |
| Wrong branch during deploy | Started on `gh-pages` | Checkout `main`, run script |

General tips:

- Always keep `hugo.yaml` baseURL aligned with the custom domain.
- Avoid committing generated site files to `main` (only source + `public/`).
- Review the script before modifying deployment behavior.


---

For more, see: [Hugo Docs](https://gohugo.io/documentation/) · [PaperMod Docs](https://adityatelange.github.io/hugo-PaperMod/).
