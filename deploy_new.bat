@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo    Quarto Incremental Build and Deploy
echo ==========================================

echo.
echo Enter filename(s) to render (space-separated):
echo Example: 2017-ggtext.rmd 2018-tidyplots.rmd
echo Or press Enter to skip rendering and deploy only
echo.
set /p FILES=Filename: 

if "%FILES%"=="" (
    echo.
    echo [Skip] Deploying existing files...
    goto deploy
)

echo.
echo [1/2] Rendering files...
cd doc

set RENDER_SUCCESS=1
set RENDER_COUNT=0
set FAIL_COUNT=0

:: Loop through files
for %%f in (%FILES%) do (
    echo.
    echo --- Rendering: %%f ---
    
    if not exist "%%f" (
        echo [ERROR] File not found: %%f
        set RENDER_SUCCESS=0
        set /a FAIL_COUNT+=1
    ) else (
        call quarto render "%%f"
        if !errorlevel! neq 0 (
            echo [ERROR] %%f render failed!
            set RENDER_SUCCESS=0
            set /a FAIL_COUNT+=1
        ) else (
            echo [OK] %%f rendered successfully
            set /a RENDER_COUNT+=1
        )
    )
)

cd ..

echo.
echo ==========================================
echo Stats: Success !RENDER_COUNT!, Failed !FAIL_COUNT!
echo ==========================================

:: Ask to continue if any failed
if "!RENDER_SUCCESS!"=="0" (
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
if "!RENDER_COUNT!"=="0" if !FAIL_COUNT! gtr 0 (
    echo.
    echo [ERROR] No files rendered successfully. Cancelled.
    pause
    exit /b 1
)

:deploy
echo.
echo [2/2] Deploying to Vercel...
call npx vercel public --prod --yes

if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Deployment failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo              Done!
echo Deployed to Vercel successfully!
echo ==========================================
pause
