#!/bin/bash

# GitHub Projects 機能デモンストレーション
# 使用方法: ./demo-github-projects.sh

echo "======================================"
echo "GitHub Projects Integration Demo"
echo "======================================"
echo

echo "このデモでは、GitHub Projects v2 API 連携機能を紹介します。"
echo

# 1. 基本機能の紹介
echo "1. 利用可能なスクリプト:"
echo "   - github-projects.sh: メインAPI連携スクリプト"
echo "   - add-issue-3.sh: Issue #3 専用登録スクリプト"
echo "   - test-github-projects.sh: テストスクリプト"
echo

# 2. 設定確認
echo "2. 設定ファイル (mcp.json) 内容:"
if [ -f "mcp.json" ]; then
    echo "   ✅ GitHub Projects 設定が追加されています"
    grep -A 10 "github_projects" mcp.json | sed 's/^/   /'
else
    echo "   ❌ mcp.json が見つかりません"
fi
echo

# 3. 使用例の表示
echo "3. 使用例:"
echo
echo "   a) Issue #3 をプロジェクトに追加（推奨）:"
echo "      ./add-issue-3.sh PVT_kwDOPUfJgM4AlKZF"
echo
echo "   b) 直接 API を使用:"
echo "      ./github-projects.sh add-issue 3 PVT_kwDOPUfJgM4AlKZF"
echo
echo "   c) API 接続テスト:"
echo "      ./github-projects.sh test-connection 0"
echo

# 4. 事前準備の説明
echo "4. 事前準備:"
echo "   a) GitHub Personal Access Token の設定:"
echo "      export GITHUB_TOKEN=\"your_token_here\""
echo
echo "   b) 必要な権限:"
echo "      - project (Projects の読み書き)"
echo "      - repo (Repository への読み書き)"
echo
echo "   c) Project ID の取得方法:"
echo "      GitHub Projects の URL から PVT_ で始まる文字列をコピー"
echo "      例: https://github.com/users/username/projects/1"
echo "          → PVT_kwDOPUfJgM4AlKZF"
echo

# 5. テスト実行
echo "5. 基本テストの実行:"
if [ -x "./test-github-projects.sh" ]; then
    echo "   テストを実行中..."
    echo "   ----------------------------------------"
    ./test-github-projects.sh
    echo "   ----------------------------------------"
else
    echo "   ❌ test-github-projects.sh が見つかりません"
fi
echo

# 6. エラーハンドリングデモ
echo "6. エラーハンドリングのデモ:"
echo "   a) 引数なしでの実行:"
if [ -x "./github-projects.sh" ]; then
    echo "      $ ./github-projects.sh"
    ./github-projects.sh 2>&1 | sed 's/^/      /'
else
    echo "      ❌ github-projects.sh が見つかりません"
fi
echo

echo "   b) 無効なアクションでの実行:"
if [ -x "./github-projects.sh" ]; then
    echo "      $ ./github-projects.sh invalid-action 3 project-id"
    result=$(./github-projects.sh invalid-action 3 project-id 2>&1)
    echo "      $result"
    if [ "$result" = "error" ]; then
        echo "      ✅ 正しく 'error' が出力されました"
    else
        echo "      ❌ 期待される出力と異なります"
    fi
else
    echo "      ❌ github-projects.sh が見つかりません"
fi
echo

echo "======================================"
echo "デモ完了"
echo "======================================"
echo
echo "実際に使用する場合は、GITHUB_TOKEN を設定してから"
echo "適切な Project ID で実行してください。"
echo
echo "詳細については README-github-projects.md を参照してください。"