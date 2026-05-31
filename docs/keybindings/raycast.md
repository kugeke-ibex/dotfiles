# Raycast App Hotkeys

Raycast の各 Extension / アプリ起動に割り当てたグローバルホットキーのメモ。

> Raycast 自体の設定 (Hotkey 含む) は SQLite DB に保存されテキスト diff で管理できないため、
> このファイルは **ヒト読み用の控え**。 完全な復元は [config/raycast/README.md](../../config/raycast/README.md) のエクスポート / インポート手順を使う。
>
> ホットキーは Raycast App → Settings → Extensions → 各 App の "Record Hotkey" で記録する。

## アプリ起動

### Editor

| アプリ             | ホットキー        |
| ------------------ | ----------------- |
| Visual Studio Code | `Opt+Cmd+Shift+V` |
| Cursor             | `Opt+Cmd+Shift+C` |

### Browser

| アプリ        | ホットキー    |
| ------------- | ------------- |
| Google Chrome | `Opt+Shift+C` |
| Arc           | `Opt+Shift+A` |

### Container Tool

| アプリ         | ホットキー       |
| -------------- | ---------------- |
| OrbStack       | `Opt+Shift+O`    |
| Docker Desktop | `Opt+Shift+D` ⚠️ |

### Chat Tool

| アプリ  | ホットキー    |
| ------- | ------------- |
| Slack 2 | `Opt+Shift+S` |

### DB Tool

| アプリ    | ホットキー    |
| --------- | ------------- |
| TablePlus | `Opt+Shift+T` |

### AI Tool

| アプリ  | ホットキー        |
| ------- | ----------------- |
| ChatGPT | `Opt+Shift+G`     |
| Codex   | `Opt+Cmd+Shift+D` |

### Video Tool

| アプリ | ホットキー    |
| ------ | ------------- |
| Loom   | `Opt+Shift+L` |

### Capture Tool

| アプリ | ホットキー        |
| ------ | ----------------- |
| Cyazo  | `Opt+Cmd+Shift+G` |

### Memo Tool

| アプリ | ホットキー    |
| ------ | ------------- |
| Notion | `Opt+Shift+N` |

### Development Tool

| アプリ  | ホットキー    |
| ------- | ------------- |
| Postman | `Opt+Shift+P` |

### Translation Tool

| アプリ | ホットキー       |
| ------ | ---------------- |
| DeepL  | `Opt+Shift+D` ⚠️ |

## Raycast 組み込み

| アクション        | ホットキー    |
| ----------------- | ------------- |
| Clipboard History | `Cmd+Shift+V` |

## ⚠️ 競合するホットキー

| ホットキー    | 競合するアプリ         | 備考                                                                              |
| ------------- | ---------------------- | --------------------------------------------------------------------------------- |
| `Opt+Shift+D` | Docker Desktop / DeepL | Raycast 上で後勝ち (last-write-wins) になるため、どちらか別キーに変更する必要あり |
