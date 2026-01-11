@echo off
chcp 65001 >nul
echo ========================================
echo    部署到服务器 r.wk8686.toip
echo ========================================
echo.
echo 正在上传文件到服务器...
echo.

scp -o StrictHostKeyChecking=no -r "E:\99 其它\05 R语言\public\*" root@112.74.48.143:/opt/1panel/apps/openresty/openresty/www/sites/r.wk8686.top/index/

echo.
if %errorlevel% equ 0 (
    echo [成功] 文件上传完成！
    echo 正在修复文件权限...
    ssh root@112.74.48.143 "chown -R 1000:1000 /opt/1panel/apps/openresty/openresty/www/sites/r.wk8686.top/index/"
    echo [成功] 部署完成！
    echo 访问地址: https://r.wk8686.top
) else (
    echo [失败] 部署出错，请检查网络连接或 SSH 配置
)
echo.
pause
