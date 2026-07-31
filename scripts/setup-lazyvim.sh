#!/usr/bin/env bash
set -euo pipefail

TS="$(date +%Y%m%d-%H%M%S)"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

VIM_DIR="$HOME/.vim"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"

backup_path() {
  local path="$1"
  if [ -e "$path" ]; then
    echo "Backing up: $path -> ${path}.bak-$TS"
    mv "$path" "${path}.bak-$TS"
  fi
}

echo "==> Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  echo "Install Homebrew first, then rerun this script."
  exit 1
fi

ARCH="$(uname -m)"
BREW_BIN="$(command -v brew)"
BREW_PREFIX="$(brew --prefix)"

echo "==> Detected architecture: $ARCH"
echo "==> brew path: $BREW_BIN"
echo "==> brew prefix: $BREW_PREFIX"

if [ "$ARCH" != "arm64" ]; then
  echo "This script is intended for Apple Silicon Macs such as M1/M2/M3/M4."
  exit 1
fi

if [ "$BREW_PREFIX" != "/opt/homebrew" ]; then
  echo "Warning: On Apple Silicon, Homebrew should usually be installed at /opt/homebrew"
  echo "Current prefix: $BREW_PREFIX"
  echo "This may cause slow installs or source builds."
fi

BREW_CMD=(arch -arm64 brew)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/brew-install-bottles.sh"
source "$SCRIPT_DIR/lib/macports-install.sh"

echo "==> Updating Homebrew"
"${BREW_CMD[@]}" update

echo "==> Installing required packages"
FORMULAS=(neovim git ripgrep fd lazygit fzf tmux tree-sitter)

brew_formulas=()

brew_formulas=("${FORMULAS[@]}")
if [ "${#brew_formulas[@]}" -gt 0 ]; then
  echo "Attempting Homebrew bottles for: ${brew_formulas[*]}"
  mapfile -t missing_bottles < <(brew_install_bottles "${BREW_CMD[@]}" -- "${brew_formulas[@]}")
  if [ "${#missing_bottles[@]}" -gt 0 ]; then
    echo "Homebrew bottles missing for: ${missing_bottles[*]}."
    echo "Falling back to MacPorts for missing bottles."
    macports_install "${missing_bottles[@]}"
  fi
fi

if command -v npm >/dev/null 2>&1; then
  echo "==> Installing tree-sitter CLI via npm"
  npm install -g tree-sitter-cli
else
  echo "npm not found; skipping tree-sitter-cli install."
fi

if [ -e "$CONFIG_DIR" ]; then
  if [ -f "$CONFIG_DIR/lazyvim.json" ] || [ -f "$CONFIG_DIR/lazy-lock.json" ]; then
    echo "LazyVim config already exists at $CONFIG_DIR. Skipping backup and LazyVim setup."
    echo "Done."
    exit 0
  fi
fi

echo "==> Backing up existing Neovim config if it exists"
backup_path "$CONFIG_DIR"
backup_path "$DATA_DIR"
backup_path "$STATE_DIR"
backup_path "$CACHE_DIR"

echo "==> Backing up existing Vim config if it exists"
backup_path "$VIM_DIR"
backup_path "$VIMRC"
backup_path "$GVIMRC"

if [ -e "$CONFIG_DIR" ]; then
  echo "Neovim config already exists at $CONFIG_DIR. Skipping LazyVim setup."
else
  echo "==> Cloning LazyVim starter"
  git clone https://github.com/LazyVim/starter "$CONFIG_DIR"
  rm -rf "$CONFIG_DIR/.git"

  mkdir -p "$CONFIG_DIR/lua/plugins"
  mkdir -p "$CONFIG_DIR/lua/config"

  echo "==> Writing plugin bundle"
  cat >"$CONFIG_DIR/lua/plugins/backend.lua" <<'EOF'
return {
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

  { "christoomey/vim-tmux-navigator", lazy = false },
  { "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gvdiffsplit" } },
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
  { "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },
  { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy", opts = {} },
  { "nvim-telescope/telescope.nvim", cmd = "Telescope", opts = {} },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      autotag = { enable = true },
      ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "json",
        "lua",
        "markdown",
        "terraform",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = { enabled = true },
      popupmenu = { enabled = true },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  { "akinsho/bufferline.nvim", event = "VeryLazy", opts = { options = { mode = "tabs" } } },
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = {} },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
EOF

  echo "==> Writing options"
  cat >"$CONFIG_DIR/lua/config/options.lua" <<'EOF'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
EOF

  echo "==> Writing autocmds"
  cat >"$CONFIG_DIR/lua/config/autocmds.lua" <<'EOF'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
EOF

  echo "==> Writing keymaps"
  cat >"$CONFIG_DIR/lua/config/keymaps.lua" <<'EOF'
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux right" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
EOF
  echo "==> Syncing plugins"
  nvim --headless "+Lazy! sync" +qa
fi
