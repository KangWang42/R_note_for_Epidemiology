@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo       Quarto 网站全量构建与部署
echo ==========================================

echo.
echo [1/2] 正在构建网站 (Quarto)...
echo 注意：将渲染 doc 目录下的所有文件

:: 使用 quarto render 命令渲染 doc 目录
call quarto render doc
if !errorlevel! neq 0 (
    echo.
    echo ==========================================
    echo [ERROR] Build failed!
    echo Please check doc folder for errors.
    echo ==========================================
    pause
    exit /b 1
)

echo.
echo [OK] All files rendered successfully

echo.
echo [2/2] Deploying to Vercel...

:: 执行 Vercel 部署
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
