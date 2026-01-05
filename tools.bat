@echo off
chcp 65001
title YouTube 批量下载助手（固定进度显示 + 高画质）

:: 下载目录设置为软件所在目录下的 Downloads 文件夹
set DOWNLOAD_DIR=%~dp0Downloads
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

echo ============================================
echo         YouTube 批量下载助手
echo 下载目录: %DOWNLOAD_DIR%
echo ============================================
echo.

:DOWNLOAD_LOOP
set URL=
set /p URL=请输入YouTube视频网址（或输入 exit 退出）: 

if /i "%URL%"=="exit" goto END

:: 清理链接参数
for /f "tokens=1 delims=&" %%i in ("%URL%") do set CLEAN_URL=%%i

echo.
echo 正在解析并下载视频...
echo 视频链接（已清理参数）: %CLEAN_URL%
echo.

:: 下载最高画质 + 音质，固定一行显示进度
yt-dlp.exe -f "bestvideo+bestaudio/best" --merge-output-format mkv ^
-o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" ^
--concurrent-fragments 16 ^
--progress ^
--no-playlist ^
--console-title ^
--newline ^
"%CLEAN_URL%"

if errorlevel 1 (
    echo.
    echo 下载出错！请检查网络或视频是否可用。
    pause
)

echo.
echo 下载完成！文件已保存到: %DOWNLOAD_DIR%
echo.
echo -----------------------------
echo 准备下一个视频
echo -----------------------------
echo.

goto DOWNLOAD_LOOP

:END
echo.
echo 所有下载任务已完成，程序退出。
pause >nul
