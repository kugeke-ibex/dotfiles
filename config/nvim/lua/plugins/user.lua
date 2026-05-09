-- 参考リストから、LazyVim 本体と役割が被らないものだけ追加
-- (fern/telescope/nvim-cmp/lualine 等は入れない)

return {
  {
    "mattn/vim-findroot",
    event = "VeryLazy",
  },

  {
    "simeji/winresizer",
    keys = {
      { "<leader>wr", "<cmd>WinResizerStartResize<cr>", desc = "WinResizer" },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "VeryLazy",
    cmd = {
      "Git",
      "GitBlame",
      "GitDiff",
      "GitBrowse",
    },
    keys = {
      { "<leader>gtb", "<cmd>GitBlame<cr>", desc = "Git blame (git.nvim)" },
      { "<leader>gtd", "<cmd>GitDiff<cr>", desc = "Git diff (git.nvim)" },
    },
    config = function()
      require("git").setup({ default_mappings = false })
    end,
  },

  {
    "vim-jp/nvimdoc-ja",
    lazy = false,
  },

  {
    "thinca/vim-qfreplace",
    cmd = { "Qfreplace" },
    ft = "qf",
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      {
        "<C-z>",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        mode = "n",
        desc = "Comment toggle",
      },
      {
        "<C-z>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        mode = "x",
        desc = "Comment toggle (visual)",
      },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Dial increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Dial decrement",
      },
      {
        "<C-a>",
        function()
          return require("dial.map").inc_visual()
        end,
        mode = "v",
        expr = true,
        desc = "Dial increment (visual)",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_visual()
        end,
        mode = "v",
        expr = true,
        desc = "Dial decrement (visual)",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hexadecimal,
          augend.constant.alias.bool,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
        },
      })
    end,
  },
}
