local nvim_create_user_command = vim.api.nvim_create_user_command

-- jqをVim上で実行
nvim_create_user_command("JsonFormatter", function()
  vim.cmd([[
    if !executable('jq')
      call s:echo_err("not found jq command.")
    endif

    execute("%!jq '.'")
  ]])
end, {})

-- xmlを整形
nvim_create_user_command("XmlFormatter", function()
  local success, error_message = pcall(function()
    vim.cmd([[ execute("%s/></>\r</g | filetype indent on | setf xml | normal gg=G") ]])
  end)

  if not success then
    vim.notify("[xml format]" .. error_message, vim.log.levels.ERROR)
  end
end, {})

-- Cspellのユーザー辞書に単語を追加する処理
nvim_create_user_command("CspellAppend", function(opts)
  local word = opts.args or ""

  if word == "" then
    word = vim.fn.expand("<cword>"):lower()
  end

  if word == "" then
    vim.notify("Word not set.", vim.log.levels.ERROR)
  end

  local cspell_dirs = {
    dotfiles = vim.call("expand", "~/.config/cspell/dotfiles.txt"),
    user = vim.call("expand", "~/.local/share/cspell/user.txt"),
  }

  local dictionary_name = opts.bang and "dotfiles" or "user"

  vim.fn.system(string.format("echo %s >> %s", word, cspell_dirs[dictionary_name]))

  if vim.api.nvim_get_option_value("modifiable", {}) then
    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
    vim.api.nvim_command("silent! undo")
  end

  vim.notify(word .. " added to " .. dictionary_name .. " dictionary.", vim.log.levels.INFO)
end, {
  nargs = "?",
  bang = true,
})

-- Ctopをfloating window内で実行するコマンド
nvim_create_user_command("Ctop", function()
  if vim.fn.executable("ctop") == 0 then
    vim.notify("ctop command not found.", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "single",
  })

  vim.fn.termopen("ctop", {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end, {})

-- LazyGitをfloating window内で実行するコマンド
nvim_create_user_command("LazyGit", function()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit command not found.", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "single",
  })

  vim.fn.termopen("lazygit", {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end, {})
