# Raycast Configuration

Raycast の設定 (Hotkey 含む) は内部 SQLite DB に保存され、テキスト diff で管理できないため、
バイナリエクスポート (`.rayconfig`) を **手動で** 取得して `raycast.rayconfig` として
このディレクトリに置く運用。

## エクスポート手順

1. Raycast を起動 (`Cmd+Space` 等)
2. Settings → "Advanced" → "Import / Export" → Export
3. 出力された `.rayconfig` を `config/raycast/raycast.rayconfig` として保存
4. **コミット前に内容を確認** (機密情報が含まれる可能性、下記参照)

## インポート手順 (新規マシンへの復元)

1. Raycast を起動
2. Settings → "Advanced" → "Import / Export" → Import
3. `config/raycast/raycast.rayconfig` を選択

## 機密情報チェック

`.rayconfig` には以下が含まれる可能性があります:

- AI Provider API key (OpenAI, Anthropic, Google 等)
- 各 extension のアクセストークン (Linear, GitHub, Slack 等)
- Snippet の内容 (個人情報が混入する場合あり)

### 推奨運用

エクスポート前に以下を Raycast 側で確認・退避:

1. **AI Provider**: Settings → AI で API key を一時的に削除 → エクスポート → 再設定
2. **Extension の認証**: Linear / GitHub 等の Connected アカウントを **Logout** → エクスポート → 再ログイン
3. **Snippets**: 機密を含む snippet を **個別に削除** → エクスポート → 後で再追加

または、`git-secrets` / `pre-commit` に `.rayconfig` の binary 検査を組み込む。

## Cloud Sync (代替)

Raycast Pro (有料) を契約していれば、設定は Raycast Cloud で同期される。
その場合は `config/raycast/raycast.rayconfig` 管理は不要。
