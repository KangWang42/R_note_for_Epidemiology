@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo    Quarto Auto-detect Changes and Deploy
echo ==========================================

echo.
echo [1/3] Detecting modified files in Git...
cd doc

set MODIFIED=0

:: Get modified .rmd and .qmd files
for /f "delims=" %%i in ('git diff --name-only HEAD -- "*.rmd" "*.qmd" 2^>nul') do (
    set MODIFIED=1
    echo   Modified: %%i
)

:: Get untracked new files
for /f "delims=" %%i in ('git ls-files --others --exclude-standard -- "*.rmd" "*.qmd" 2^>nul') do (
    set MODIFIED=1
    echo   New file: %%i
)

if !MODIFIED!==0 (
    echo   No .rmd/.qmd changes detected
    echo.
    set /p CONFIRM=Continue deploying anyway? (y/n): 
    if /i not "!CONFIRM!"=="y" (
        echo Cancelled
        cd ..
        pause
        exit /b 0
    )
    cd ..
    goto deploy
)

echo.
echo [2/3] Rendering changed files...

set RENDER_SUCCESS=1
set RENDER_COUNT=0
set FAIL_COUNT=0

:: Render modified files
for /f "delims=" %%i in ('git diff --name-only HEAD -- "*.rmd" "*.qmd" 2^>nul') do (
    echo --- Rendering: %%i ---
    call quarto render "%%i"
    if !errorlevel! neq 0 (
        echo [ERROR] %%i render failed!
        set RENDER_SUCCESS=0
        set /a FAIL_COUNT+=1
    ) else (
        echo [OK] %%i rendered successfully
        set /a RENDER_COUNT+=1
    )
)

:: Render new files
for /f "delims=" %%i in ('git ls-files --others --exclude-standard -- "*.rmd" "*.qmd" 2^>nul') do (
    echo --- Rendering: %%i ---
    call quarto render "%%i"
    if !errorlevel! neq 0 (
        echo [ERROR] %%i render failed!
        set RENDER_SUCCESS=0
        set /a FAIL_COUNT+=1
    ) else (
        echo [OK] %%i rendered successfully
        set /a RENDER_COUNT+=1
    )
)

cd ..

echo.
echo ==========================================
echo Stats: Success !RENDER_COUNT!, Failed !FAIL_COUNT!
echo ==========================================

:: Ask to continue if any failed
if !RENDER_SUCCESS!==0 (
    echo.
    echo [WARNING] Some files failed to render!
    set /p CONTINUE=Continue deploying? (y/n): 
    if /i not "!CONTINUE!"=="y" (
        echo Cancelled.
        pause
        exit /b 1
    )
)

:: Don't deploy if nothing succeeded
if !RENDER_COUNT!==0 if !FAIL_COUNT! gtr 0 (
    echo.
    echo [ERROR] No files rendered successfully. Cancelled.
    pause
    exit /b 1
)

:deploy
echo.
echo [3/3] Deploying to Surge...
call npx surge public my-stat-r.surge.sh

if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Deployment failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo              Done!
echo Visit: https://my-stat-r.surge.sh/
echo ==========================================
pause
