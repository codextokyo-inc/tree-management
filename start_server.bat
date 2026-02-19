@echo off
chcp 65001 > nul
echo ========================================
echo re:leaf - ローカルサーバー起動
echo ========================================
echo.
echo サーバーを起動しています...
echo ブラウザで以下のURLにアクセスしてください:
echo.
echo   http://localhost:8000/map/
echo.
echo 終了するには Ctrl+C を押してください
echo ========================================
echo.

start http://localhost:8000/map/

python -m http.server 8000
