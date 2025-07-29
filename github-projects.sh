#!/bin/bash

# GitHub Projects v2 API Integration Script
# 使用方法: ./github-projects.sh <action> <issue_number> [project_id]

# 引数の数をチェック
if [ $# -lt 2 ]; then
    echo "使用方法: $0 <action> <issue_number> [project_id]"
    echo "例: $0 add-issue 3 PVT_kwDOPUfJgM4AlKZF"
    echo "対応アクション: add-issue, get-project, test-connection"
    exit 1
fi

# 引数を変数に代入
action=$1
issue_number=$2
project_id=${3:-""}

# 設定ファイルから設定を読み込み
config_file="mcp.json"
if [ ! -f "$config_file" ]; then
    echo "error"
    exit 1
fi

# GitHub API の基本設定
GITHUB_API_URL="https://api.github.com"
GITHUB_GRAPHQL_URL="https://api.github.com/graphql"
REPO_OWNER="keisatoh"
REPO_NAME="copilot-agent-sandbox"

# GitHub トークンの確認
if [ -z "$GITHUB_TOKEN" ]; then
    echo "error"
    exit 1
fi

# GraphQL クエリの実行関数
execute_graphql_query() {
    local query=$1
    local variables=$2
    
    curl -s -H "Authorization: bearer $GITHUB_TOKEN" \
         -H "Content-Type: application/json" \
         -X POST \
         -d "{\"query\": \"$query\", \"variables\": $variables}" \
         "$GITHUB_GRAPHQL_URL"
}

# Issue をプロジェクトに追加する関数
add_issue_to_project() {
    local issue_num=$1
    local proj_id=$2
    
    if [ -z "$proj_id" ]; then
        echo "error"
        exit 1
    fi
    
    # Issue の ID を取得
    issue_query="query(\$owner: String!, \$name: String!, \$number: Int!) { 
        repository(owner: \$owner, name: \$name) { 
            issue(number: \$number) { 
                id 
            } 
        } 
    }"
    issue_variables="{\"owner\": \"$REPO_OWNER\", \"name\": \"$REPO_NAME\", \"number\": $issue_num}"
    
    issue_response=$(execute_graphql_query "$issue_query" "$issue_variables")
    
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1
    fi
    
    # JSON レスポンスから Issue ID を抽出 (jq がない場合のシンプルな方法)
    issue_id=$(echo "$issue_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [ -z "$issue_id" ]; then
        echo "error"
        exit 1
    fi
    
    # Issue をプロジェクトに追加
    add_mutation="mutation(\$projectId: ID!, \$contentId: ID!) { 
        addProjectV2ItemById(input: {projectId: \$projectId, contentId: \$contentId}) { 
            item { 
                id 
            } 
        } 
    }"
    add_variables="{\"projectId\": \"$proj_id\", \"contentId\": \"$issue_id\"}"
    
    add_response=$(execute_graphql_query "$add_mutation" "$add_variables")
    
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1
    fi
    
    # 成功メッセージを出力
    item_id=$(echo "$add_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [ -n "$item_id" ]; then
        echo "success: Issue #$issue_num added to project $proj_id"
    else
        echo "error"
        exit 1
    fi
}

# プロジェクト情報を取得する関数
get_project_info() {
    local proj_id=$1
    
    if [ -z "$proj_id" ]; then
        echo "error"
        exit 1
    fi
    
    project_query="query(\$id: ID!) { 
        node(id: \$id) { 
            ... on ProjectV2 { 
                title 
                url 
            } 
        } 
    }"
    project_variables="{\"id\": \"$proj_id\"}"
    
    project_response=$(execute_graphql_query "$project_query" "$project_variables")
    
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1
    fi
    
    # プロジェクトタイトルを抽出
    project_title=$(echo "$project_response" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$project_title" ]; then
        echo "Project: $project_title"
    else
        echo "error"
        exit 1
    fi
}

# 接続テスト関数
test_connection() {
    viewer_query="query { viewer { login } }"
    viewer_variables="{}"
    
    viewer_response=$(execute_graphql_query "$viewer_query" "$viewer_variables")
    
    if [ $? -ne 0 ]; then
        echo "error"
        exit 1
    fi
    
    # ユーザー名を抽出
    username=$(echo "$viewer_response" | grep -o '"login":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$username" ]; then
        echo "Connected as: $username"
    else
        echo "error"
        exit 1
    fi
}

# アクションに応じて処理を実行
case $action in
    "add-issue")
        add_issue_to_project "$issue_number" "$project_id"
        ;;
    "get-project")
        get_project_info "$project_id"
        ;;
    "test-connection")
        test_connection
        ;;
    *)
        echo "error"
        exit 1
        ;;
esac