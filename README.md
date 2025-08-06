# My Blogsite

This is a personal blog built with [Hugo](https://gohugo.io/) using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

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

## Deploying to GitHub Pages
- Push the contents of the `public/` directory to your `gh-pages` branch or your GitHub Pages repository (e.g., `lenzoman.github.io`).
- You can automate this with a deploy script or GitHub Actions.

## Running as a GitHub Pages Site
1. Build your site:
   ```sh
   hugo
   ```
2. Copy the contents of the `public/` directory to the root of your `lenzoman.github.io` repository.
3. Commit and push the changes to the `main` (or `master`) branch of `https://github.com/LenzoMan/lenzoman.github.io`:
   ```sh
   cd public
   git init
   git remote add origin https://github.com/LenzoMan/bytes-n-stuff.git 
   git add .
   git commit -m "Deploy site"
   git branch -M main
   git push -f origin main
   ```
4. Your site will be published at: https://lenzoman.github.io/

## Managing Content
- Add new posts in `my-blogsite/content/posts/` using Markdown files.
- To mark a post as archived, add `archived: true` to its front matter.
- To publish a post, set `draft: false` in its front matter.

## Cleaning Up
- Do not edit the `public/` directory directly; it is auto-generated.
- Keep all content and configuration in the `my-blogsite/` directory.

## Troubleshooting
- If you see `Unable to locate config file or config directory`, make sure you are in the `my-blogsite/` directory when running Hugo commands.

---
For more details, see the [Hugo Documentation](https://gohugo.io/documentation/) and [PaperMod Theme Docs](https://adityatelange.github.io/hugo-PaperMod/).
