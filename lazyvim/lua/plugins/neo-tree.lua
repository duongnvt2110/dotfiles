return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      open_files_do_not_replace_types = {
        "terminal",
        "Trouble",
        "trouble",
        "qf",
        "Outline",
        "edgy",
      },

      window = {
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<CR>"] = "open",
          ["l"] = "open",
          ["t"] = "open_tabnew",
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false, -- show/hide .env, .git, etc.
          hide_gitignored = false, -- this is what you want
          hide_ignored = false,
          hide_hidden = false,
        },
        commands = {
          -- Override delete to use trash instead of rm
          delete = function(state)
            local path = state.tree:get_node().path
            local os = vim.loop.os_uname().sysname

            local function fallback_trash()
              local cwd = vim.fn.getcwd()
              local trash_dir = cwd .. "/.Trash"

              vim.fn.mkdir(trash_dir, "p")

              local filename = vim.fn.fnamemodify(path, ":t")
              local target = trash_dir .. "/" .. filename

              vim.fn.rename(path, target)

              vim.notify("Moved to fallback trash:\n" .. target, vim.log.levels.WARN)
            end

            local success = false

            if os == "Darwin" then
              local script = string.format('tell application "Finder" to delete POSIX file %q', path)

              vim.fn.system({
                "osascript",
                "-e",
                script,
              })

              success = vim.v.shell_error == 0
            else
              if vim.fn.executable("gio") == 1 then
                vim.fn.system({
                  "gio",
                  "trash",
                  path,
                })

                success = vim.v.shell_error == 0
              elseif vim.fn.executable("trash-put") == 1 then
                vim.fn.system({
                  "trash-put",
                  path,
                })

                success = vim.v.shell_error == 0
              end
            end

            if not success then
              fallback_trash()
            end

            require("neo-tree.sources.manager").refresh(state.name)
          end,
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
      },
    },
  },
}
