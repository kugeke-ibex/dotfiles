-- zsh file type detection based on shebang lines
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "" then
      return
    end
    local first_line = vim.fn.getline(1)
    if first_line:match("^#!/usr/bin/env zsh") or first_line:match("^#!/bin/zsh") then
      vim.bo.filetype = "zsh"
    end
  end,
})
