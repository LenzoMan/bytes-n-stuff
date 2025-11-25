# Contributing to Bytes & Stuff

Thank you for wanting to improve this blog! This guide helps you maintain the project structure and ensure smooth contributions.

## Quick Start

### Adding a New Post

```bash
# 1. Create a new post
hugo new posts/my-post-title.md

# 2. Edit the post in your editor
#    - Update front matter (title, date, tags, categories, description)
#    - Write your content in Markdown
#    - Keep draft: true while writing

# 3. Test locally
hugo serve
# Visit http://localhost:1313

# 4. When ready to publish
#    - Set draft: false in front matter
#    - Commit your changes

# 5. Deploy
./deploy.sh
```

## Post Front Matter

Every post must have proper front matter. Use the template created by `hugo new`:

```yaml
---
title: "Your Post Title Here"
date: 2025-11-25T10:00:00Z
description: "A brief description of your post (used in metadata)"
draft: true
tags: ["tag1", "tag2"]
categories: ["category"]
---

Your post content starts here...
```

### Front Matter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `title` | Yes | Post title |
| `date` | Yes | Publication date in ISO 8601 format |
| `description` | No | Brief summary (shows in previews) |
| `draft` | Yes | Set to `false` to publish, `true` to hide |
| `tags` | No | Array of tags for organization |
| `categories` | No | Array of categories for grouping |
| `archive` | No | Set to `true` for archived posts (optional) |

## Writing Guidelines

### Markdown Style

- Use **Markdown** for all posts
- Keep lines reasonably short for readability
- Use proper heading hierarchy: `#` (H1 - title only), `##` (H2 - sections), `###` (H3 - subsections)
- Use code blocks with language specification:

  ```markdown
  \`\`\`python
  # Your code here
  print("Hello, World!")
  \`\`\`
  ```

### Content Best Practices

- Write in a clear, conversational tone
- Break up long paragraphs
- Use lists and bullet points for clarity
- Include links to resources when relevant
- Proofread before publishing

## Development Workflow

### 1. Create Your Branch (Optional but Recommended)

```bash
git checkout -b feature/my-new-post
```

### 2. Make Your Changes

```bash
# Add a new post
hugo new posts/my-post.md

# Edit the file
vim content/posts/my-post.md

# Test your changes
hugo serve
```

### 3. Verify Your Changes

Before committing:

```bash
# Run validation checks
./scripts/pre-deploy-check.sh

# Or manually check
hugo
# Visit http://localhost:1313
```

### 4. Commit Your Changes

Use clear, descriptive commit messages:

```bash
# Good commit messages
git commit -m "content: add post about [topic]"
git commit -m "docs: update README with new instructions"
git commit -m "chore: update dependencies"

# Bad commit messages
git commit -m "update stuff"
git commit -m "fix"
```

### 5. Push and Deploy

```bash
# Push your changes
git push origin main

# Deploy to GitHub Pages
./deploy.sh
```

## Commit Message Convention

Use the following prefixes for clarity:

| Prefix | Use Case | Example |
|--------|----------|---------|
| `content:` | New or updated blog posts | `content: add post on AI trends` |
| `docs:` | Documentation changes | `docs: update README` |
| `chore:` | Configuration, dependencies | `chore: update theme` |
| `fix:` | Bug fixes | `fix: correct post date` |
| `refactor:` | Restructuring without changes | `refactor: reorganize posts` |
| `style:` | Formatting, no functionality change | `style: fix markdown formatting` |

## What NOT to Do

❌ **Don't:**
- Edit files in the `public/` directory directly
- Commit the `public/` directory to the main branch
- Modify `themes/PaperMod/` directly (it's a Git submodule)
- Delete or rename posts without using `git mv`
- Push directly to the `gh-pages` branch
- Modify `deploy.sh` without understanding the implications

✅ **Do:**
- Add new posts to `content/posts/`
- Test locally with `hugo serve` before deploying
- Run `./scripts/pre-deploy-check.sh` before deploying
- Use `git` for all file operations (mv, rm, etc.)
- Keep commit messages clear and descriptive
- Document any configuration changes in comments

## Troubleshooting

### Post Not Appearing on Live Site

**Issue:** I published a post but it's not showing up.

**Causes & Fixes:**
- Check that `draft: false` is set in front matter
- Verify the file is in `content/posts/`
- Run `hugo` to rebuild locally
- Check that `./deploy.sh` completed without errors
- Wait 1-2 minutes for GitHub Pages to rebuild

### Build Error: "cannot find theme"

**Issue:** `hugo serve` or `hugo` fails with theme error.

**Fix:**
```bash
# Initialize and update Git submodules
git submodule update --init --recursive
```

### Accidentally Modified Theme Files

**Issue:** I accidentally edited something in `themes/PaperMod/`.

**Fix:**
```bash
# Restore the theme to original state
git checkout -- themes/PaperMod/
# Or if that doesn't work
git submodule update --init --recursive
```

### Can't Undo a Commit

**Issue:** I committed something I shouldn't have.

**Fixes:**
```bash
# If not yet pushed - use git revert
git revert <commit-hash>
git push origin main

# If already pushed - check git log and see what happened
git log --oneline
```

## Pre-Deployment Checklist

Before running `./deploy.sh`, verify:

- [ ] All new posts are in `content/posts/`
- [ ] Posts marked as `draft: false` are ready for publication
- [ ] No accidental files in root directory
- [ ] Hugo builds without errors: `hugo`
- [ ] `static/CNAME` contains the correct domain
- [ ] `.git/` directory is present
- [ ] Run `./scripts/pre-deploy-check.sh` passes

## Getting Help

- **Project Structure:** See `PROJECT_STRUCTURE.md`
- **Build & Deploy:** See `README.md`
- **Hugo Documentation:** [https://gohugo.io/documentation/](https://gohugo.io/documentation/)
- **PaperMod Theme:** [https://github.com/adityatelange/hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## Questions?

Feel free to check the existing documentation files or test locally before deploying.

Happy writing! ✨
