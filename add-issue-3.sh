#!/bin/bash

# Issue #3 自動登録スクリプト
# 使用方法: ./add-issue-3.sh <project_id>

# 引数の数をチェック
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <project_id>"
    echo "例: $0 PVT_kwDOPUfJgM4AlKZF"
    echo ""
    echo "このスクリプトは Issue #3 を指定された GitHub Project に自動登録します。"
    echo "Project ID の取得方法:"
    echo "1. GitHub で対象プロジェクトを開く"
    echo "2. URLから PVT_ で始まる文字列をコピー"
    echo "   例: https://github.com/users/username/projects/1 → PVT_kwDOPUfJgM4AlKZF"
    exit 1
fi

# 引数を変数に代入
project_id=$1

# GitHub Projects スクリプトの存在確認
if [ ! -x "./github-projects.sh" ]; then
    echo "error"
    exit 1
fi

# Issue #3 を指定されたプロジェクトに追加
echo "Issue #3 をプロジェクトに追加中..."
result=$(./github-projects.sh add-issue 3 "$project_id" 2>&1)

# 結果の確認
if echo "$result" | grep -q "success:"; then
    echo "✅ $result"
    echo ""
    echo "Issue #3 が正常にプロジェクトに追加されました。"
    echo "GitHub Projects でステータスを「To Do」に設定することをお勧めします。"
else
    echo "❌ プロジェクトへの追加に失敗しました: $result"
    echo ""
    echo "エラーの原因:"
    echo "- GITHUB_TOKEN 環境変数が設定されていない"
    echo "- Project ID が正しくない"
    echo "- Issue #3 が既にプロジェクトに追加されている"
    echo "- プロジェクトへのアクセス権限がない"
    exit 1
fi