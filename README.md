# fzfnpm

A simple way to launch npm scripts from a package.json using fzf.

<p align="center">
  <img src="./.assets/fzfnpm.gif" alt="fzfpng in action" width='100%' />
</p>

> No more `cat package.json` or `npm run` just launch `fzfnpm`.

## Features

- **Smart package manager detection** - Automatically detects npm, yarn, or pnpm
- **Bookmark system** - Your last used script appears at the top for quick access (just press Enter again)
- **Project-specific memory** - Each project remembers its own script history

## Install with homebrew

```bash
brew tap FrancisVega/taps
brew install fzfnpm
```

