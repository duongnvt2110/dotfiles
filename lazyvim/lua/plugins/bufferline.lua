return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
        custom_filter = function(bufnr)
          -- Hide neo-tree
          if vim.bo[bufnr].filetype == "neo-tree" then
            return false
          end

          -- Always show modified buffers
          if vim.bo[bufnr].modified then
            return true
          end

          -- Show current buffer
          if bufnr == vim.api.nvim_get_current_buf() then
            return true
          end

          -- Hide other unmodified buffers
          return false
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },
  -- {
  --   "LazyVim/LazyVim",
  --   keys = {
  --     {
  --       "<Tab>",
  --       "<cmd>BufferLineCycleNext<cr>",
  --       desc = "Next Buffer",
  --     },
  --     {
  --       "<S-Tab>",
  --       "<cmd>BufferLineCyclePrev<cr>",
  --       desc = "Previous Buffer",
  --     },
  --     {
  --       "<leader>bd",
  --       "<cmd>bdelete<cr>",
  --       desc = "Close Buffer",
  --     },
  --   },
  -- },
}
