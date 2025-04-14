#!/bin/bash
set -e

# エラーハンドリング関数
handle_error() {
    echo "❌ エラー発生箇所: ${1}行目"
    exit 1
}
trap 'handle_error ${LINENO}' ERR

# 現在のディレクトリを確認
echo "📁 カレントディレクトリ: $(pwd)"

# venv環境が存在するか確認
if [ ! -d "venv" ]; then
    echo "🔧 venv環境を作成します..."
    python3 -m venv venv
    echo "✅ venv環境を作成しました"
fi

# venv環境をアクティベート
echo "🔧 venv環境をアクティベートします..."
source venv/bin/activate
echo "✅ venv環境をアクティベートしました: $(which python)"

# パッケージインストール
echo "📦 必要なパッケージをインストールします..."
pip install -r requirements.txt
echo "✅ パッケージのインストールが完了しました"

# DB接続確認
echo "🔍 データベース接続を確認します..."
python -c 'from models.database import engine; print("✅ DB接続に成功しました")'

# FastAPIアプリ起動
echo "🚀 サーバーを起動します..."
uvicorn main:app --reload --host 0.0.0.0 --port 8000