@echo off
echo ========================================================
echo   Starting Spotter - 3D Weather-Aware Truck Routing
echo ========================================================

REM 1. Start Django Backend API in a separate window
start "Spotter Backend (Django)" cmd /k "python backend\manage.py runserver 127.0.0.1:8000"

REM 2. Start Vite Frontend Dev Server in a separate window
start "Spotter Frontend (Vite)" cmd /k "cd frontend && npm run dev"

REM 3. Give servers a moment to spin up, then open browser
timeout /t 3 /nobreak >nul
start http://localhost:5173

echo.
echo Spotter servers launched!
echo Frontend UI:    http://localhost:5173
echo Backend API:    http://127.0.0.1:8000/api/health
echo ========================================================

