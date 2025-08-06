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

## Updating Content

- Add new posts in `my-blogsite/content/posts/` using Markdown files.
- To mark a post as archived, add `archived: true` to its front matter.
- To publish a post, set `draft: false` in its front matter.

## Deploying and Syncing the Site

To automate updating, building, and deploying your site, use the provided `deploy.sh` script:

1. Make sure you are in the `my-blogsite` directory.
2. Run:

   ```sh
   ./deploy.sh
   ```

This script will:

- Pull the latest changes from the remote repository
- Stage and commit your local changes
- Build the Hugo site
- Stage and commit the generated `public/` directory
- Push all changes to the remote repository

## Manual Deployment (if needed)

If you want to deploy manually:

1. Build your site:

   ```sh
   hugo
   ```

2. Go to the `public` directory:

   ```sh
   cd public
   ```

3. Add, commit, and push changes:

   ```sh
   git add .
   git commit -m "Deploy site"
   git push origin main
   cd ..
   ```

## Cleaning Up

- Do not edit the `public/` directory directly; it is auto-generated.
- Keep all content and configuration in the `my-blogsite/` directory.

## Troubleshooting

- If you see `Unable to locate config file or config directory`, make sure you are in the `my-blogsite/` directory when running Hugo commands.
- If you see push errors, always pull first: `git pull origin main`

---

For more details, see the [Hugo Documentation](https://gohugo.io/documentation/) and [PaperMod Theme Docs](https://adityatelange.github.io/hugo-PaperMod/).
