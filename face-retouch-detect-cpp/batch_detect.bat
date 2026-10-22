@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"
set /p SRC=Enter path to the folder of images to detect: 
set /p OUT=Enter path to the output folder: 
if "%SRC%"=="" (
  echo No input path provided. Cancelled.
  pause
  exit /b 1
)
if "%OUT%"=="" set OUT=%SRC%_results
echo.
echo Starting detection...
face_retouch_detect.exe --models .\models --src "%SRC%" --out "%OUT%"
echo.
echo Done. Output folder: %OUT%
pause
