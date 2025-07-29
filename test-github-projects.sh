#!/bin/bash

# GitHub Projects 機能のテストスクリプト
# 使用方法: ./test-github-projects.sh

echo "=== GitHub Projects Integration Test ==="
echo

# スクリプトの存在確認
if [ ! -f "./github-projects.sh" ]; then
    echo "❌ ERROR: github-projects.sh が見つかりません"
    exit 1
fi

if [ ! -x "./github-projects.sh" ]; then
    echo "❌ ERROR: github-projects.sh に実行権限がありません"
    exit 1
fi

echo "✅ github-projects.sh が見つかりました"

# 設定ファイルの確認
if [ ! -f "./mcp.json" ]; then
    echo "❌ ERROR: mcp.json が見つかりません"
    exit 1
fi

echo "✅ mcp.json が見つかりました"

# GitHub トークンの確認
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  WARNING: GITHUB_TOKEN 環境変数が設定されていません"
    echo "   実際のAPI呼び出しテストはスキップされます"
    token_available=false
else
    echo "✅ GITHUB_TOKEN が設定されています"
    token_available=true
fi

echo

# 基本的な引数テスト
echo "=== 基本的な引数テスト ==="

echo -n "引数なしテスト: "
output=$(./github-projects.sh 2>&1)
if echo "$output" | grep -q "使用方法"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
fi

echo -n "引数不足テスト: "
output=$(./github-projects.sh add-issue 2>&1)
if echo "$output" | grep -q "使用方法"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
fi

echo -n "無効なアクションテスト: "
output=$(./github-projects.sh invalid-action 3 project-id 2>&1)
if [ "$output" = "error" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL (出力: $output)"
fi

echo

# GitHub API 接続テスト（トークンがある場合のみ）
if [ "$token_available" = true ]; then
    echo "=== GitHub API 接続テスト ==="
    
    echo -n "API接続テスト: "
    output=$(./github-projects.sh test-connection 0 2>&1)
    if echo "$output" | grep -q "Connected as:"; then
        echo "✅ PASS ($output)"
    else
        echo "❌ FAIL (出力: $output)"
    fi
    
    echo
fi

# 設定ファイルテスト
echo "=== 設定ファイルテスト ==="

echo -n "mcp.json形式テスト: "
if command -v python3 >/dev/null 2>&1; then
    if python3 -m json.tool mcp.json >/dev/null 2>&1; then
        echo "✅ PASS (有効なJSON)"
    else
        echo "❌ FAIL (無効なJSON)"
    fi
elif command -v node >/dev/null 2>&1; then
    if node -e "JSON.parse(require('fs').readFileSync('mcp.json', 'utf8'))" >/dev/null 2>&1; then
        echo "✅ PASS (有効なJSON)"
    else
        echo "❌ FAIL (無効なJSON)"
    fi
else
    echo "⚠️  SKIP (JSON検証ツールなし)"
fi

echo -n "github_projects設定確認: "
if grep -q "github_projects" mcp.json; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
fi

echo

echo "=== テスト完了 ==="
echo "注意: 実際のプロジェクトIDでのテストは手動で実行してください"
echo "例: ./github-projects.sh add-issue 3 YOUR_PROJECT_ID"