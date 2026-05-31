---
description: Plan または引数で指定された実装内容を Codex/Cursor に委譲 (統合版)
argument-hint: [--to=codex|cursor] [実装仕様 or 追加制約]
---

Plan または引数で指定された実装内容を、指定された委譲先 (Codex または Cursor) に委譲してください。

## 実施手順

### ステップ 0: 委譲先 (DEST) の判定

`$ARGUMENTS` の先頭トークンを確認し、委譲先を決定する:

| 先頭トークン          | DEST           | 引数の扱い                                            |
| --------------------- | -------------- | ----------------------------------------------------- |
| `--to=codex`          | `codex`        | 先頭トークンを除去した残りを以降で使用                |
| `--to=cursor`         | `cursor`       | 先頭トークンを除去した残りを以降で使用                |
| `--to=<その他>`       | -              | エラー表示して終了 (`codex` と `cursor` のみサポート) |
| 未指定 (`--to=` なし) | `codex` (既定) | `$ARGUMENTS` はそのまま使用                           |

**以降のステップでは「除去後の引数」をユーザー指定仕様として扱うこと**。元の `$ARGUMENTS` ではなく、除去後の値を参照する。

`--to=<その他>` の場合は以下を出力して終了:

```
⚠️  /delegate-v2: 未サポートの委譲先です

--to= に指定可能な値: codex, cursor
例: /delegate-v2 --to=cursor modules/xxx に RFI rule を追加
```

### ステップ 1: 入力の判定

「除去後の引数」と現在の会話履歴から、以下 4 パターンのいずれかを判定してください:

| #   | Plan の有無 | 引数の有無 | 動作                                  |
| --- | ----------- | ---------- | ------------------------------------- |
| 1   | あり        | なし       | Plan を使って委譲                     |
| 2   | あり        | あり       | Plan を使い、引数は追加制約として注入 |
| 3   | なし        | あり       | 引数を仕様として直接委譲              |
| 4   | なし        | なし       | **警告出力して終了**（委譲しない）    |

**Plan の判定基準**:

- 直近の `ExitPlanMode` で確定した Plan が存在する
- または、直前の会話でユーザーが承認した実装方針が明確にある

**引数の判定基準**:

- 「除去後の引数」が空文字列でない、かつ意味のある仕様記述を含む

### ステップ 2: パターン別の処理

#### パターン 4（Plan なし + 引数なし）

以下の警告を出力してそのまま終了してください。**委譲は行わない**こと:

```
⚠️  /delegate-v2: 委譲する内容がありません

以下のいずれかが必要です:
  1. 直前の会話で Plan を確定させる（Plan モード or 対話的合意）
  2. 引数に実装仕様を直接指定

使用例:
  /delegate-v2                                       # Plan 確定後に Codex 委譲
  /delegate-v2 --to=cursor                           # Plan 確定後に Cursor 委譲
  /delegate-v2 modules/xxx に RFI rule を追加         # Codex に仕様直接指定
  /delegate-v2 --to=cursor modules/xxx に RFI rule を追加  # Cursor に仕様直接指定
```

#### パターン 1・2（Plan あり）

抽出した Plan を以下の構造で委譲先プロンプトに整形:

```markdown
# 目的

<Plan の主要目的>

# 合意済みの方針

- <Plan の主要ポイント 1>
- <Plan の主要ポイント 2>

# スコープ

- **対象**: <Plan で言及された範囲>
- **除外**: <触ってはいけない場所>

# 参照すべき既存ファイル

- <Plan で確認したファイル>

# 制約

- 既存の命名規則に従う
- 破壊的変更なし
- <Plan で議論された制約>
- ユーザーからの追加指示: <除去後の引数> # パターン 2 のみ。空なら省略

# 検証項目

- <Plan に応じて fmt / validate / test など>

# 戻り値の形式

- 変更・作成したファイルのパス一覧
- 各変更の要約
- 実行推奨の検証コマンド
```

#### パターン 3（Plan なし + 引数あり）

「除去後の引数」を仕様として以下の構造で整形:

```markdown
# 目的

<除去後の引数>

# スコープ

<除去後の引数> から推測される対象ファイル / ディレクトリ。
スコープが曖昧な場合は、委譲先で最小範囲に絞って実装すること。

# 制約

- 既存の命名規則・コーディング規約に従う
- 破壊的変更なし
- 既存の動作を壊さない
- 指示にない範囲のファイルは変更しない

# 検証項目

- 対象言語の fmt / validate / test が通ること（該当する場合）

# 戻り値の形式

- 変更・作成したファイルのパス一覧
- 各変更の要約
- 実行推奨の検証コマンド
```

### ステップ 3: 委譲先への実行

委譲先によってエントリーポイントが異なる:

| DEST   | 方式                | エントリーポイント                        | 依存                                       |
| ------ | ------------------- | ----------------------------------------- | ------------------------------------------ |
| codex  | **プラグイン経由**  | `scripts/codex-companion.mjs` (Node 実行) | OpenAI 公式プラグイン `codex@openai-codex` |
| cursor | **公式 CLI 直叩き** | `cursor-agent -p ...`                     | Cursor 公式 CLI のみ (プラグイン不要)      |

> **設計意図**: Codex には OpenAI 公式プラグインが存在するためそれを利用する。一方 Cursor の Claude Code 連携プラグイン (`yangtau/claude-agents-plugins`) は非公式・Star 0 の個人プロジェクトのため、サプライチェーンリスク回避のために Cursor 公式 CLI (`cursor-agent`) を直接叩く。

#### 3-0. 委譲先パラメータの解決

```bash
case "$DEST" in
  cursor)
    DEST_LABEL="Cursor"
    FALLBACK_CMD=""                                         # 手動フォールバック用スラッシュコマンドなし
    SETUP_HINT="curl https://cursor.com/install -fsSL | bash"
    # PLUGIN_KEY / SCRIPT_PATH は不要（CLI 直叩き）
    ;;
  *)
    DEST_LABEL="Codex"
    PLUGIN_KEY="codex@openai-codex"
    SCRIPT_PATH="scripts/codex-companion.mjs"
    FALLBACK_CMD="/codex:rescue"
    SETUP_HINT="/codex:setup"
    ;;
esac
```

#### 3-1. 整形プロンプトを一時ファイルへ書き出す

シェル引数の quoting を回避するため、整形プロンプトはヒアドキュメントで一時ファイルに書き出す（DEST 共通）:

```bash
PROMPT_FILE=$(mktemp -t delegate-v2-prompt.XXXXXX)
cat > "$PROMPT_FILE" <<'PROMPT_EOF'
<ステップ 2 で整形したプロンプト全文をここに貼り付け>
PROMPT_EOF
```

#### 3-2. エントリーポイントの検証

##### 3-2-a. DEST=codex: プラグインスクリプトパスを解決

ハードコードを避けるため、プラグインマネージャが管理する `~/.claude/plugins/installed_plugins.json` の `installPath` から解決する:

```bash
COMPANION_SCRIPT=$(PLUGIN_KEY="$PLUGIN_KEY" SCRIPT_PATH="$SCRIPT_PATH" node -e '
  const fs = require("fs");
  const path = require("path");
  try {
    const cfg = path.join(process.env.HOME, ".claude/plugins/installed_plugins.json");
    if (!fs.existsSync(cfg)) { process.exit(10); }
    const p = JSON.parse(fs.readFileSync(cfg, "utf8"));
    const installs = (p.plugins || {})[process.env.PLUGIN_KEY] || [];
    if (installs.length === 0) { process.exit(11); }
    const cwd = process.cwd();
    const m =
      installs.find(i => i.projectPath === cwd) ||
      installs.find(i => i.scope === "user") ||
      installs[0];
    const script = path.join(m.installPath, process.env.SCRIPT_PATH);
    if (!fs.existsSync(script)) { process.exit(12); }
    console.log(script);
  } catch (e) {
    console.error(e.message);
    process.exit(13);
  }
')
RESOLVE_RC=$?
```

##### 3-2-b. DEST=cursor: `cursor-agent` CLI の存在確認

```bash
if command -v cursor-agent >/dev/null 2>&1; then
  RESOLVE_RC=0
else
  RESOLVE_RC=20
fi
```

解決結果の判定（DEST 統合）:

| 終了コード | DEST   | 意味                                                                             | 次のアクション     |
| ---------- | ------ | -------------------------------------------------------------------------------- | ------------------ |
| `0`        | 共通   | 成功                                                                             | 3-3 へ進む         |
| `10`       | codex  | `installed_plugins.json` が存在しない                                            | 3-4 フォールバック |
| `11`       | codex  | `$PLUGIN_KEY` のプラグインが未インストール                                       | 3-4 フォールバック |
| `12`       | codex  | プラグインは検出されたが `$SCRIPT_PATH` が見当たらない（レイアウト変更の可能性） | 3-4 フォールバック |
| `13`       | codex  | JSON 破損など予期せぬ例外                                                        | 3-4 フォールバック |
| `20`       | cursor | `cursor-agent` CLI が PATH 上に見つからない                                      | 3-4 フォールバック |

#### 3-3. 成功時: 委譲先を実行

##### 3-3-a. DEST=codex

`--write` を付けて書き込み可能モードで呼び出し、stdout をそのまま受け取る:

```bash
node "$COMPANION_SCRIPT" task --write "$(cat "$PROMPT_FILE")"
TASK_RC=$?
rm -f "$PROMPT_FILE"
```

##### 3-3-b. DEST=cursor

`cursor-agent` を print mode (`-p`) で呼び出す。`-p` は非対話・ヘッドレス実行で、stdout に結果を書き出す。ファイル書き込みは Cursor CLI のデフォルト動作で有効:

```bash
cursor-agent -p "$(cat "$PROMPT_FILE")"
TASK_RC=$?
rm -f "$PROMPT_FILE"
```

共通事項:

- **フォアグラウンド実行**（`run_in_background` は使わない）
- stdout が委譲先の返答。ステップ 4 のレビューに渡す
- `$TASK_RC` が非ゼロなら 3-4 のフォールバックへ

#### 3-4. 失敗時: 手動実行へのフォールバック

`RESOLVE_RC` が `10/11/12/13/20`、または `TASK_RC` が非ゼロの場合は、以下を日本語でユーザーに提示して **そのまま終了** すること。**Claude Code 側での代替実装は絶対に試みない**:

##### DEST=codex の場合

````text
⚠️  /delegate-v2: Codex への自動委譲に失敗しました

原因: <下表の終了コード別文言>

対処:
  1. /codex:setup で Codex プラグインを整備する、または
  2. 以下の整形済みプロンプトを手動で /codex:rescue に渡してください

--- 整形済みプロンプト ---
<$PROMPT_FILE の中身を ```text コードブロックで全文表示>
````

##### DEST=cursor の場合

````text
⚠️  /delegate-v2: Cursor への自動委譲に失敗しました

原因: <下表の終了コード別文言>

対処:
  1. cursor-agent CLI をインストールする:
     curl https://cursor.com/install -fsSL | bash
     インストール後、PATH が通っていることを確認 (which cursor-agent)
  2. 以下の整形済みプロンプトをターミナルで直接実行することも可能:
     cursor-agent -p "<プロンプト内容>"

--- 整形済みプロンプト ---
<$PROMPT_FILE の中身を ```text コードブロックで全文表示>
````

終了コード別の原因文言:

- `RESOLVE_RC=10`: Claude Code プラグイン設定ファイル `~/.claude/plugins/installed_plugins.json` が見つかりません (Codex)
- `RESOLVE_RC=11`: Codex プラグイン (`codex@openai-codex`) が未インストールです
- `RESOLVE_RC=12`: Codex プラグインは検出されましたが、内部スクリプト `scripts/codex-companion.mjs` のレイアウトが想定と異なります（プラグインのバージョン変更の可能性あり — `/plugin` で再インストールを検討してください）
- `RESOLVE_RC=13`: Codex プラグイン設定ファイルの読み込み中に予期せぬエラーが発生しました（stderr を参照）
- `RESOLVE_RC=20`: `cursor-agent` CLI が PATH 上に見つかりません。Cursor 公式 CLI が未インストールか、シェルの PATH が通っていない可能性があります
- `TASK_RC≠0`: $DEST_LABEL の実行が非ゼロ終了コードで失敗しました（stderr を参照）

最後に `$PROMPT_FILE` が残っていれば `rm -f "$PROMPT_FILE"` でクリーンアップすること。

### ステップ 4: レビューとユーザーへの提示

委譲先から返ってきた結果を元に:

1. 変更ファイルを `Read` で確認
2. Plan / 仕様との整合性をチェック
3. 以下を日本語でユーザーに提示:
   - 委譲先 (Codex / Cursor) の明記
   - 変更ファイル一覧（パス付きリンク）
   - 主要な変更内容の要約
   - Plan / 仕様との整合性確認結果
   - 推奨される次のステップ（検証コマンド、確認ポイントなど）

## 厳守事項

- **Claude Code 自身では実装しない**。必ず選択した委譲先の companion スクリプト経由で委譲する
- パターン 4（Plan・引数ともになし）の場合は**警告のみ**。実装提案や推測実行は行わない
- Plan が曖昧・不完全な場合は、委譲前にユーザーに確認を求める
- 委譲先が失敗・中断した場合は、その旨をユーザーに報告し、**Claude Code 側での代替実装は試みない**
- 委譲先の返答内の file path / line number はそのまま保持（改変しない）
- `--to=` の値が `codex`/`cursor` 以外の場合は、推測せずエラー終了する
