@echo off
echo ==================================================
echo   Parkinson's Tremor Detection - Backend Server
echo ==================================================
echo.

cd backend

echo Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://www.python.org/
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
pip install -r requirements.txt

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo ==================================================
echo   Starting Flask API Server on port 5000
echo ==================================================
echo.
echo Backend URL: http://localhost:5000
echo.
echo Available Endpoints:
echo   POST /api/tremor/analyze
echo   GET  /api/caregiver/dashboard
echo   GET  /api/doctor/dashboard
echo   GET  /api/patient/history
echo.
echo Press Ctrl+C to stop the server
echo ==================================================
echo.

python app.py

pause
