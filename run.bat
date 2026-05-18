@echo off
echo =========================================
echo   Starting LeetCode Explainer App
echo =========================================
echo.

echo [1/2] Starting Python Backend Server...
REM Start the backend in a new command prompt window (API key is read from .env)
start "LeetCode Explainer - Backend" cmd /k "cd /d c:\Disk_D\HAD_project\leetcode_explainer\backend && c:\Disk_D\HAD_project\.venv\Scripts\uvicorn.exe main:app --reload --host 127.0.0.1 --port 8000"

REM Give the backend a moment to start
echo Waiting for backend to start...
timeout /t 5 /nobreak >nul

echo [2/2] Starting Flutter Web App on Chrome...
cd /d c:\Disk_D\HAD_project\leetcode_explainer\frontend\flutter_app
flutter run -d chrome
