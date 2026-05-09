-- Mason の LSP 以外ツールを参考リストどおり自動インストール
-- (:MasonToolsInstall / run_on_start)

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "biome",
          "cspell",
          "eslint_d",
          "prettier",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },
}
