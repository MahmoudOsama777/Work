@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences
for /F "delims=#" %%a in ('"prompt #$H# & echo on & for %%b in (1) do rem"') do set "DEL=%%a"

:: Initialize totals
set "total_white=0"
set "total_black=0"

:: Base directory
set "base_dir=%cd%"

:: Find last yy-mm folder
set "last_month="
for /f "delims=" %%d in ('dir /ad /b /o-n "%base_dir%" ^| findstr /r "^[0-9][0-9]-[0-9][0-9]$"') do (
    set "last_month=%%d"
    goto :found_last
)
:found_last

if not defined last_month (
    echo([91mNo yy-mm folder found.[0m
    pause
    exit /b 1
)

:: Extract month number (e.g., "11" from "25-11")
for /f "tokens=2 delims=-" %%M in ("!last_month!") do set "month_num=%%M"

set "month_path=%base_dir%\%last_month%"
if not exist "%month_path%" (
    echo([91mMonth folder missing: %last_month%[0m
    pause
    exit /b 1
)

:: First line: show only month number, bold white
echo [97;1mLast month folder:  %month_num%[0m
echo.

:: Header
echo [97;1mDay    	    White   Black   Total[0m
echo [90m----------------------------------------[0m

:: Process each day
for /f "delims=" %%D in ('dir /ad /b "%month_path%" ^| findstr /r "^[0-9][0-9]-[0-9][0-9]$"') do (
    set "white_count=0"
    set "black_count=0"

    :: Count White* PNGs (recursive)
    for /f "delims=" %%W in ('dir /ad /b "%month_path%\%%D\" 2^>nul ^| findstr /i /b "White"') do (
        for /f %%C in ('dir /s /b "%month_path%\%%D\%%W\*.png" 2^>nul ^| find /c /v ""') do (
            set /a white_count+=%%C
        )
    )

    :: Count Black* PNGs (recursive)
    for /f "delims=" %%B in ('dir /ad /b "%month_path%\%%D\" 2^>nul ^| findstr /i /b "Black"') do (
        for /f %%C in ('dir /s /b "%month_path%\%%D\%%B\*.png" 2^>nul ^| find /c /v ""') do (
            set /a black_count+=%%C
        )
    )

    set /a daily_total=white_count + black_count
    set /a total_white+=white_count
    set /a total_black+=black_count

    :: Format with fixed width, right-aligned
    set "day=%%D        "
    set "w=       !white_count!"
    set "b=       !black_count!"
    set "t=       !daily_total!"

    set "day=!day:~0,8!"
    set "w=!w:~-7!"
    set "b=!b:~-7!"
    set "t=!t:~-7!"

    echo [36m!day![0m [92;1m!w![0m [91;1m!b![0m [93;1m!t![0m
)

:: FINAL LINE — styled like your example: "Total Images: 1635   2613   4248"
set /a grand_total=total_white + total_black

set "tw=%total_white%"
set "tb=   %total_black%"
set "tt=    %grand_total%"

set "tw=!tw:~-7!"
set "tb=!tb:~-7!"
set "tt=!tt:~-7!"

echo [90m----------------------------------------[0m
echo [97;1mTotal Images:[0m [92;1m!tw![0m [91;1m!tb![0m [93;1m!tt![0m
echo.

pause