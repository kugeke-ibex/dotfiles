---
name: git-worktree
description: git worktree を使って複数ブランチを並行で扱う手順を案内・実行する。
disable-model-invocation: true
---

## 使い分け

- 別ブランチを**同じリポジトリで同時に**触りたいときに worktree を使う。
- パス・ブランチ名はユーザーまたはリポジトリの慣習に合わせる（例：`../repo-feature-x`）。

## よく使うコマンド例

- 既存ブランチを別ディレクトリに：`git worktree add <path> <branch>`
- 新規ブランチ付き：`git worktree add -b <new-branch> <path> <base-branch>`
- 一覧：`git worktree list`
- 終了時：`git worktree remove <path>`（マージ後に不要な worktree を片付ける）

## 注意

- 同じブランチを複数 worktree でチェックアウトできない。
- 作業後、ユーザーに残す worktree と削除するものを確認する。
