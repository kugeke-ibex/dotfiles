---
description: Plan または引数で指定された実装内容を Codex に委譲
argument-hint: [実装仕様 or 追加制約]
---

Plan または引数で指定された実装内容を Codex に委譲してください。

## 実施手順

### ステップ 1: 入力の判定

Plan の有無 (直近の `ExitPlanMode` 確定 or 直前の会話でユーザーが承認した方針) と `$ARGUMENTS` の有無 (空でなく意味のある仕様記述を含む) から、以下 4 パターンを判定:

| # | Plan | 引数 | 動作 |
|---|---|---|---|
| 1 | ✓ | - | Plan を使って委譲 |
| 2 | ✓ | ✓ | Plan を使い、引数は追加制約として注入 |
| 3 | - | ✓ | 引数を仕様として直接委譲 |
| 4 | - | - | **警告出力して終了**（委譲しない） |

### ステップ 2: パターン別の処理

#### パターン 4（Plan なし + 引数なし）

以下の警告を出力してそのまま終了してください。**委譲は行わない**こと：

```
⚠️  /delegate: 委譲する内容がありません

以下のいずれかが必要です：
  1. 直前の会話で Plan を確定させる（Plan モード or 対話的合意）
  2. 引数に実装仕様を直接指定

使用例：
  /delegate                                # Plan 確定後に委譲
  /delegate modules/xxx に RFI rule を追加   # 仕様直接指定
```

#### パターン 1・2・3 共通テンプレート

以下の構造で Codex プロンプトに整形。`[Plan]` マーカー付きセクションはパターン 1・2 のみ、`[P2]` は 2 のみ:

```markdown
# 目的
<Plan あり: Plan の主要目的 / Plan なし: $ARGUMENTS>

# 合意済みの方針 [Plan]
- <Plan の主要ポイント>

# スコープ
<Plan あり: **対象** / **除外** を Plan から抽出>
<Plan なし: $ARGUMENTS から推測。曖昧なら Codex 側で最小範囲に絞る>

# 参照すべき既存ファイル [Plan]
- <Plan で確認したファイル>

# 制約
- 既存の命名規則・コーディング規約に従う
- 破壊的変更なし
- 既存の動作を壊さない
- 指示にない範囲のファイルは変更しない
- <Plan で議論された制約> [Plan]
- ユーザーからの追加指示: $ARGUMENTS [P2]

# 検証項目
- 対象言語の fmt / validate / test が通ること（Plan に指定があればそれを優先）

# 戻り値の形式
- 変更・作成したファイルのパス一覧
- 各変更の要約
- 実行推奨の検証コマンド
```

### ステップ 3: Codex への委譲

Codex プラグインの内部スクリプト `codex-companion.mjs` を Bash から直接実行する。

#### 3-1. 整形プロンプトを一時ファイルへ書き出す

シェル引数の quoting を回避するため、ヒアドキュメントで一時ファイルに書き出す。

```bash
PROMPT_FILE=$(mktemp -t delegate-prompt.XXXXXX)
cat > "$PROMPT_FILE" <<'PROMPT_EOF'
<ステップ 2 で整形したプロンプト全文をここに貼り付け>
PROMPT_EOF
```

#### 3-2. Codex プラグインのスクリプトパスを解決

`~/.claude/plugins/installed_plugins.json` の `installPath` から解決する（バージョン自動追従のため）。`RESOLVE_RC=0` で成功、それ以外は 3-4 フォールバック:

```bash
CODEX_SCRIPT=$(node -e '
  const fs = require("fs");
  const path = require("path");
  try {
    const cfg = path.join(process.env.HOME, ".claude/plugins/installed_plugins.json");
    if (!fs.existsSync(cfg)) { process.exit(10); }
    const p = JSON.parse(fs.readFileSync(cfg, "utf8"));
    const installs = (p.plugins || {})["codex@openai-codex"] || [];
    if (installs.length === 0) { process.exit(11); }
    const cwd = process.cwd();
    const m =
      installs.find(i => i.projectPath === cwd) ||
      installs.find(i => i.scope === "user") ||
      installs[0];
    const script = path.join(m.installPath, "scripts/codex-companion.mjs");
    if (!fs.existsSync(script)) { process.exit(12); }
    console.log(script);
  } catch (e) {
    console.error(e.message);
    process.exit(13);
  }
')
RESOLVE_RC=$?
```

#### 3-3. 成功時: Codex を実行

`--write` で書き込み可能モード。stdout をそのまま受け取る:

```bash
node "$CODEX_SCRIPT" task --write "$(cat "$PROMPT_FILE")"
TASK_RC=$?
rm -f "$PROMPT_FILE"
```

- **フォアグラウンド実行**（`run_in_background` は使わない）
- stdout が Codex の返答。ステップ 4 のレビューに渡す
- `$TASK_RC` が非ゼロなら 3-4 のフォールバックへ

#### 3-4. 失敗時: 手動実行へのフォールバック

`RESOLVE_RC` が `10/11/12/13`、または `TASK_RC` が非ゼロの場合は、以下を日本語でユーザーに提示して **そのまま終了** すること。**Claude Code 側での代替実装は絶対に試みない**：

```text
⚠️  /delegate: Codex への自動委譲に失敗しました

原因: <下表の終了コード別文言>

対処:
  1. /codex:setup で Codex プラグインを整備する、または
  2. 以下の整形済みプロンプトを手動で /codex:rescue に渡してください

--- 整形済みプロンプト ---
<$PROMPT_FILE の中身を ``` コードブロックで全文表示>
```

終了コード別の原因文言：

- `RESOLVE_RC=10`: Claude Code プラグイン設定ファイル `~/.claude/plugins/installed_plugins.json` が見つかりません
- `RESOLVE_RC=11`: Codex プラグイン (`codex@openai-codex`) が未インストールです
- `RESOLVE_RC=12`: Codex プラグインは検出されましたが、内部スクリプト `scripts/codex-companion.mjs` のレイアウトが想定と異なります（プラグインのバージョン変更の可能性あり — `/plugin` で再インストールを検討してください）
- `RESOLVE_RC=13`: プラグイン設定ファイルの読み込み中に予期せぬエラーが発生しました（stderr を参照）
- `TASK_RC≠0`: Codex の実行が非ゼロ終了コードで失敗しました（stderr を参照）

最後に `$PROMPT_FILE` が残っていれば `rm -f "$PROMPT_FILE"` でクリーンアップすること。

### ステップ 4: レビューとユーザーへの提示

Codex から返ってきた結果を元に：

1. 変更ファイルを `Read` で確認
2. Plan / 仕様との整合性をチェック
3. 以下を日本語でユーザーに提示：
   - 変更ファイル一覧（パス付きリンク）
   - 主要な変更内容の要約
   - Plan / 仕様との整合性確認結果
   - 推奨される次のステップ（検証コマンド、確認ポイントなど）

## 厳守事項

- **Claude Code 自身では実装しない**。必ず `codex-companion.mjs` 経由で委譲し、失敗時も代替実装を試みない（詳細は `codex:codex-result-handling` skill に従う）
- パターン 4 は警告のみ。実装提案や推測実行をしない
- Plan が曖昧・不完全な場合は委譲前にユーザー確認
- Codex 返答の file path / line number はそのまま保持（改変しない）
