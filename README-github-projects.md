# GitHub Projects Integration

このプロジェクトに GitHub Projects v2 API との連携機能が追加されました。

## 概要

GitHub Issues を自動的に GitHub Projects に登録する機能を提供します。Issue #3 の要件に基づいて実装されており、シェルスクリプトベースで実現されています。

## ファイル構成

- `github-projects.sh`: GitHub Projects v2 API との連携メインスクリプト
- `add-issue-3.sh`: Issue #3 を簡単にプロジェクトに追加するためのラッパースクリプト
- `test-github-projects.sh`: 機能テスト用スクリプト
- `mcp.json`: GitHub Projects 設定を含む設定ファイル

## 事前準備

### 1. GitHub Personal Access Token の設定

GitHub Projects API を使用するため、適切な権限を持つ Personal Access Token が必要です。

```bash
export GITHUB_TOKEN="your_github_token_here"
```

必要な権限:
- `project` (Projects の読み書き)
- `repo` (Repository への読み書き)

### 2. Project ID の取得

GitHub Projects の URL から Project ID を取得します：

1. GitHub で対象プロジェクトを開く
2. URL から `PVT_` で始まる文字列をコピー
   例: `https://github.com/users/username/projects/1` → `PVT_kwDOPUfJgM4AlKZF`

## 使用方法

### Issue #3 をプロジェクトに追加（推奨）

```bash
./add-issue-3.sh PVT_kwDOPUfJgM4AlKZF
```

### 基本的な API 操作

```bash
# Issue をプロジェクトに追加
./github-projects.sh add-issue 3 PVT_kwDOPUfJgM4AlKZF

# プロジェクト情報を取得
./github-projects.sh get-project PVT_kwDOPUfJgM4AlKZF

# API 接続テスト
./github-projects.sh test-connection 0
```

### テストの実行

```bash
./test-github-projects.sh
```

## 設定

`mcp.json` ファイルで GitHub Projects の設定を管理します：

```json
{
  "github_projects": {
    "api_version": "2022-11-28",
    "base_url": "https://api.github.com/graphql",
    "default_status": "Todo",
    "project_settings": {
      "auto_register_issues": true,
      "auto_register_prs": false
    }
  }
}
```

## エラーハンドリング

既存の `calc.sh` のパターンに従い、一貫したエラーハンドリングを実装：

- エラー時は `"error"` を出力
- エラー後に `exit 1` で終了
- 引数検証と使用方法の表示

## API 仕様

### GitHub Projects v2 GraphQL API

このスクリプトは GitHub Projects v2 の GraphQL API を使用します：

- Issue ID の取得
- プロジェクトへの Item 追加
- プロジェクト情報の取得

### 対応アクション

- `add-issue`: Issue をプロジェクトに追加
- `get-project`: プロジェクト情報を取得
- `test-connection`: API 接続テスト

## トラブルシューティング

### よくあるエラー

1. **`GITHUB_TOKEN` が設定されていない**
   ```bash
   export GITHUB_TOKEN="your_token_here"
   ```

2. **Project ID が正しくない**
   - GitHub Projects の URL を確認
   - `PVT_` で始まる正しい ID を使用

3. **権限が不足している**
   - Token に `project` と `repo` 権限があることを確認

4. **Issue が既にプロジェクトに追加されている**
   - GitHub Projects で重複を確認

## 実装の詳細

- Shell script ベースの実装
- `curl` を使用した GraphQL API 呼び出し
- JSON レスポンスの shell による簡易パース
- 既存のコードスタイルとの一貫性

## 今後の拡張予定

- PR の自動プロジェクト登録
- ステータスの自動設定
- カスタムフィールドの設定
- Webhook との連携