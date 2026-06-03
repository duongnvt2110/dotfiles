return {
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
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = {} },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
      })
    end,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      -- Optional: custom keymaps
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<M-n>",
        ["Add Cursor Down"] = "<M-Down>",
        ["Add Cursor Up"] = "<M-Up>",
      }
    end,
  },
}
