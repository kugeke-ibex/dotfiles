-- タブをタブ番号 + ファイル名 + ファイル拡張子のアイコンの形式に変更する
local fn = vim.fn

local function tabline_icon(bufname)
  if bufname == "" then
    return ""
  end
  if fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
    local ok, sym = pcall(fn.WebDevIconsGetFileTypeSymbol, bufname)
    if ok and sym and sym ~= "" then
      return sym .. " "
    end
  end
  local okm, mini = pcall(require, "mini.icons")
  if okm and mini and mini.get then
    local name = fn.fnamemodify(bufname, ":t")
    local okg, glyph = pcall(function()
      return select(1, mini.get("file", name))
    end)
    if okg and glyph and glyph ~= "" then
      return glyph .. " "
    end
  end
  return ""
end

local function myTabline()
  local s = ""

  for i = 1, fn.tabpagenr("$") do
    local winnr = fn.tabpagewinnr(i)
    local buflist = fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = fn.bufname(bufnr)

    s = s .. "%" .. i .. "T"
    if i == fn.tabpagenr() then
      -- アクティブなタブページのラベル
      s = s .. "%#TabLineSel#"
    else
      -- アクティブでないタブページのラベル
      s = s .. "%#TabLine#"
    end

    -- Show tabnumber
    local tabnumber = string.format("[%s]", i)
    s = s .. tabnumber .. " "

    -- Show icon (WebDevIcons / mini.icons; 未読込時は空)
    local icon = tabline_icon(bufname)

    -- bufname
    if bufname ~= "" then
      -- ファイル名の最後にあるセミコロンと$がついている場合は削除
      local match_pattern = "%;%$"
      if string.find(bufname, match_pattern) then
        bufname = string.gsub(bufname, match_pattern, "")
      end

      if icon ~= "" then
        s = string.format("%s%s%s%s", s, icon, fn.fnamemodify(bufname, ":t"), " ")
      else
        s = string.format("%s%s%s", s, fn.fnamemodify(bufname, ":t"), " ")
      end
    else
      s = s .. "No Name" .. " "
    end
  end

  -- タブページの行のラベルがない部分
  s = s .. "%#TabLineFill#"

  return s
end

-- グローバルな関数として登録
_G.myTabline = myTabline
vim.o.tabline = "%!v:lua.myTabline()"

-- テーマ切り替え時も TabLine 行の余白を透過にそろえる（tabline 用設定はここに集約）
local function apply_tabline_fill_hl()
  vim.cmd.highlight("TabLineFill ctermbg=NONE guibg=NONE")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_tabline_fill_hl,
})
apply_tabline_fill_hl()
