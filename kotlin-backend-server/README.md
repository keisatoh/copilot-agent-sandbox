# Kotlin Backend Server

KtorフレームワークでKotlinバックエンドサーバを構築しました。

## 機能

- RESTful API エンドポイント
- JSON シリアライゼーション
- CORS サポート
- ログ機能
- ヘルスチェックエンドポイント

## エンドポイント

- `GET /` - ハローメッセージを返す
- `GET /health` - サーバのヘルスチェック

## 実行方法

```bash
./gradlew run
```

## ビルド

```bash
./gradlew build
```

サーバは http://localhost:8080 で起動します。
