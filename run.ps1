# Spotter One-Click Launcher for Windows PowerShell
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Starting Spotter - 3D Weather-Aware Truck Routing" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Start Django Backend API in a separate PowerShell window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$Host.UI.RawUI.WindowTitle = 'Spotter Backend (Django)'; Write-Host 'Spotter Django Backend running on http://127.0.0.1:8000' -ForegroundColor Green; python backend/manage.py runserver 127.0.0.1:8000"

# 2. Start Vite Frontend in a separate PowerShell window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$Host.UI.RawUI.WindowTitle = 'Spotter Frontend (Vite)'; Write-Host 'Spotter Vite Frontend running on http://localhost:5173' -ForegroundColor Cyan; Set-Location frontend; npm run dev"

# 3. Wait briefly for servers to initialize and open the browser
Start-Sleep -Seconds 3
Start-Process "http://localhost:5173"

Write-Host "`nSpotter servers launched successfully!" -ForegroundColor Green
Write-Host "• Frontend UI: http://localhost:5173" -ForegroundColor Yellow
Write-Host "• Backend API: http://127.0.0.1:8000/api/health" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Cyan

