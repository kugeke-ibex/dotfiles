-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--
-- Insert mode (Emacs-like)
--
keymap("i", "<C-a>", "<Home>", opts)
keymap("i", "<C-e>", "<End>", opts)

--
-- Increment / Decrement
--
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

--
-- Tab navigation
--
keymap("n", "<Tab>", ":tabnext<Return>", opts)
keymap("n", "<S-Tab>", ":tabprev<Return>", opts)

--
-- Window split (s prefix, mozumasu inspired)
--
keymap("n", "ss", ":split<Return>", opts)
keymap("n", "sv", ":vsplit<Return>", opts)

--
-- Window navigation (vim 風: sh/sj/sk/sl)
--
keymap("n", "sh", "<C-w>h", opts)
keymap("n", "sj", "<C-w>j", opts)
keymap("n", "sk", "<C-w>k", opts)
keymap("n", "sl", "<C-w>l", opts)

--
-- Window resize (Ctrl-w + Arrow)
--
keymap("n", "<C-w><Left>", "<C-w><", opts)
keymap("n", "<C-w><Right>", "<C-w>>", opts)
keymap("n", "<C-w><Up>", "<C-w>+", opts)
keymap("n", "<C-w><Down>", "<C-w>-", opts)

--
-- Diagnostic navigation
--
keymap("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

--
-- zz -> z -> z cycle: center -> top -> bottom -> center ...
-- ref: https://zenn.dev/vim_jp/articles/67ec77641af3f2
--
local zz_state = { pos = 0, last_time = 0 }

keymap("n", "zz", function()
  zz_state.pos = 1
  zz_state.last_time = vim.loop.now()
  vim.cmd("normal! zz")
end, { desc = "Scroll center (then z to cycle)" })

keymap("n", "z", function()
  local now = vim.loop.now()
  -- 1 秒以内かつ zz の後なら次の位置へ
  if zz_state.pos > 0 and (now - zz_state.last_time) < 1000 then
    zz_state.last_time = now
    zz_state.pos = (zz_state.pos % 3) + 1
    if zz_state.pos == 1 then
      vim.cmd("normal! zz")
    elseif zz_state.pos == 2 then
      vim.cmd("normal! zt")
    else
      vim.cmd("normal! zb")
    end
  else
    -- 通常の z (次のキーを待つ)
    zz_state.pos = 0
    local char = vim.fn.getcharstr()
    vim.cmd("normal! z" .. char)
  end
end, { desc = "Cycle scroll after zz / normal z commands" })
