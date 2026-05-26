# kickstart-modular.nvim

## Introduction

*This is a fork of [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) that moves from a single file to a multi file configuration.*

A starting point for Neovim that is:

* Small
* Modular
* Completely Documented

**NOT** a Neovim distribution, but instead a starting point for your configuration.

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation),
  [fd-find](https://github.com/sharkdp/fd#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> [!NOTE]
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> [!NOTE]
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> [!NOTE]
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart-modular.nvim.git`

You likely want to remove `lazy-lock.json` from your fork's `.gitignore` file
too - it's ignored in the kickstart repo to make maintenance easier, but it's
[recommended to track it in version control](https://lazy.folke.io/usage/lockfile).

#### Clone kickstart.nvim

> [!NOTE]
> If following the recommended step above (i.e., forking the repo), replace
> `dam9000` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/dam9000/kickstart-modular.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/dam9000/kickstart-modular.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/dam9000/kickstart-modular.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

## Customizations in this fork

This config has been tuned beyond stock kickstart-modular. Notable changes:

**Plugins added**

| Plugin | Purpose |
| :- | :- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Colorscheme (`catppuccin-mocha`) |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Top buffer/tab line with diagnostics |
| [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer (edit filesystem like a buffer) |
| [folke/flash.nvim](https://github.com/folke/flash.nvim) | Fast 2-char + treesitter motion |
| [folke/trouble.nvim](https://github.com/folke/trouble.nvim) | Modern diagnostics / symbols / refs panel |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | Dashboard, bigfile, quickfile (other modules disabled) |
| [folke/noice.nvim](https://github.com/folke/noice.nvim) | Cmdline / messages / popup UI |
| [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) (v2) | Pin & jump between project files |
| [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre) | Project-wide find & replace |
| [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Function/class/parameter text objects |
| [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) | Git diff UI |
| [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal + lazygit |
| [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) | Smarter window resizing |

**Plugins removed from stock kickstart**: `tokyonight`, `neo-tree.nvim`, standalone `Comment.nvim`, `mini.statusline` (replaced respectively by catppuccin, oil, mini.comment, lualine).

**Options enabled**: `relativenumber`, `termguicolors`, `scrolloff=8`, `expandtab`/`shiftwidth=2`, `smartindent`, no swapfile/backup, treesitter-based folding, trim trailing whitespace on save.

**Treesitter languages auto-installed**: bash, c, cpp, css, json, jsonc, yaml, toml, lua, luadoc, markdown, query, regex, vim, vimdoc, python, rust, go, javascript, typescript, tsx, html, diff.

## Keybindings cheat sheet

> Leader key is **`<Space>`**. Press `<Space>` and wait — `which-key` shows every leader binding grouped by prefix. You almost never need to memorize the full list below.

### Discoverability

| Key | Action |
| :- | :- |
| `<Space>` (then wait) | which-key popup with every leader binding |
| `<leader>sk` | Search all keymaps (Telescope) |
| `<leader>sh` | Search Neovim help docs |
| `:Tutor` | Built-in vim tutorial |

### Files & explorer (oil)

| Key | Action |
| :- | :- |
| `<leader>e` | Open oil at the current file's directory |
| `<leader>E` | Open oil at cwd |
| `<leader>fe` or `\` | Toggle a 30-col oil sidebar on the left |
| `-` | Open oil at the parent directory |

Inside oil: `<CR>` enter dir / open file, `<C-s>` open in vsplit, `<C-h>` hsplit, `<C-t>` new tab. Edit the buffer like text and `:w` to commit (rename / move / delete).

### Search (Telescope)

| Key | Action |
| :- | :- |
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Search current word |
| `<leader>sd` | Search diagnostics |
| `<leader>sk` | Search keymaps |
| `<leader>sh` | Search help |
| `<leader>sn` | Search Neovim config files |
| `<leader>s.` | Recent files |
| `<leader>sr` | Resume last search |
| `<leader>/` | Fuzzy search inside current buffer |
| `<leader><leader>` | Open buffers |

### Project find & replace (Spectre)

| Key | Action |
| :- | :- |
| `<leader>sp` | Toggle Spectre (project) |
| `<leader>sP` | Spectre on current file |
| `<leader>sp` (visual) | Spectre with selection |

### Buffers (top bufferline)

| Key | Action |
| :- | :- |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>bd` / `<leader>bD` | Delete / force-delete buffer |
| `<leader>bo` | Close other buffers |
| `<leader>bl` / `<leader>bh` | Close to right / left |
| `<leader>bp` | Pick & close (interactive) |
| `<leader>bP` | Pin / unpin |

### Harpoon

| Key | Action |
| :- | :- |
| `<leader>ha` | Add current file |
| `<leader>hh` | Toggle quick menu |
| `<leader>1` … `<leader>4` | Jump to file 1..4 |
| `<C-S-N>` / `<C-S-P>` | Next / previous harpoon item |

### Windows

| Key | Action |
| :- | :- |
| `<C-h/j/k/l>` | Move focus left / down / up / right |
| `<leader>wv` / `<leader>ws` | Vertical / horizontal split |
| `<leader>wq` / `<leader>wo` | Close current / close others |
| `<leader>w=` | Equalize sizes |
| `<A-h/j/k/l>` | Resize current window (smart-splits) |

### LSP / Code (in source files)

| Key | Action |
| :- | :- |
| `K` | Hover documentation |
| `grd` | Go to **D**efinition |
| `grr` | Find **R**eferences |
| `gri` | Go to **I**mplementation |
| `grD` | Go to **D**eclaration |
| `grt` | Go to **T**ype definition |
| `grn` | **R**e**n**ame symbol |
| `gra` | Code **A**ction |
| `gO` / `gW` | Document / workspace symbols |
| `<leader>ch` | Toggle inlay hints |
| `[d` / `]d` | Previous / next diagnostic |

Format-on-save is handled by [conform.nvim](https://github.com/stevearc/conform.nvim).

### Diagnostics (Trouble)

| Key | Action |
| :- | :- |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Symbols panel |
| `<leader>xl` | LSP refs/defs side panel |
| `<leader>xt` | TODO comments list |
| `<leader>xq` | Diagnostics → location list |

### Git

| Key | Action |
| :- | :- |
| `<leader>gg` (or `<leader>lg`) | lazygit (floating terminal) |
| `<leader>gd` / `<leader>gD` | DiffviewOpen / Close |
| `<leader>gh` / `<leader>gH` | File history (repo / current file) |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff against index |
| `]c` / `[c` | Next / previous hunk (in diffview) |

### Terminal

| Key | Action |
| :- | :- |
| `<leader>tt` | Toggle floating terminal |
| `<leader>tf` / `<leader>th` / `<leader>tv` | Float / horizontal / vertical |
| `<Esc><Esc>` | Exit terminal-insert mode |

### Motion (Flash)

| Key | Action |
| :- | :- |
| `s` | Flash jump (2-char + label) |
| `S` | Flash by treesitter node |
| `r` (operator-pending) | Remote flash, e.g. `dr` to delete a remote token |

### Treesitter text objects

Use as **operator + textobject**, e.g. `daf` deletes a function, `vif` selects inside a function, `cic` changes inside a class.

| Object | Means |
| :- | :- |
| `af` / `if` | a / inside function |
| `ac` / `ic` | a / inside class |
| `aa` / `ia` | a / inside argument/parameter |
| `ai` / `ii` | a / inside conditional |
| `al` / `il` | a / inside loop |

Plus jumps: `]f` / `[f` next/prev function, `]c` / `[c` next/prev class. Swap parameters: `<leader>cs` / `<leader>cS`.

### Mini text editing

| Key | Action |
| :- | :- |
| `gcc` / `gc{motion}` | Toggle comment line / motion (`gcap` paragraph) |
| `gc` (visual) | Comment selection |
| `saiw)` | Surround add: inside word with `(` `)` |
| `sd"` | Surround delete: `"` |
| `sr({` | Surround replace `(` with `{` |

### Quality of life

| Key | Action |
| :- | :- |
| `<C-s>` | Save file (n / i / v) |
| `<Esc>` | Clear search highlight |
| `<C-d>` / `<C-u>` | Half-page down / up (auto-centered) |
| `n` / `N` | Next / prev search match (auto-centered) |
| `J` / `K` (visual) | Move selected lines down / up |
| `<` / `>` (visual) | Indent and keep selection |
| `<leader>Q` | Force quit-all |
| `<C-space>` / `<BS>` | Treesitter incremental selection: expand / shrink |

### Startup dashboard (snacks.nvim)

When you launch `nvim` with no file:

| Key | Action |
| :- | :- |
| `f` | Find file |
| `r` | Recent files |
| `g` | Live grep |
| `c` | Edit Neovim config |
| `s` | Restore session |
| `L` | Open `:Lazy` |
| `q` | Quit |

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling) information
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * *NOTE: This is the fork that splits the configuration into smaller parts.*
    The original repo with the single `init.lua` file is available here:
    * [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

