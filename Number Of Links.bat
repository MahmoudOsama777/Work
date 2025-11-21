@echo off
setlocal enabledelayedexpansion

:: Check if files exist, create them if they don't
if not exist "01-Black.txt" (
    echo. > "01-Black.txt"
    echo Created 01-Black.txt
)
if not exist "02-White.txt" (
    echo. > "02-White.txt"
    echo Created 02-White.txt
)

:: Count lines containing "https://" in 01-Black.txt
for /f %%i in ('findstr /R /C:"https://" "01-Black.txt" ^| find /c /v ""') do set count1=%%i

:: Count lines containing "https://" in 02-White.txt
for /f %%i in ('findstr /R /C:"https://" "02-White.txt" ^| find /c /v ""') do set count2=%%i

:: Calculate total
set /a total=%count1% + %count2%

:: Output results
echo Links in 01-Black.txt: %count1%
echo Links in 02-White.txt: %count2%
echo Total links: %total%

pause