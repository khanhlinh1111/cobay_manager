@echo off
TITLE Cai dat CoBay Manager

echo ==================================================
echo      BAT DAU CAI DAT DU AN COBAY_MANAGER
echo ==================================================

:: 1. Kiểm tra Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [LOI] Khong tim thay lenh 'flutter'.
    echo Vui long cai dat Flutter SDK truoc.
    pause
    exit /b
)

echo.
echo [1/3] Dang tai cac thu vien (Flutter Pub Get)...
call flutter pub get

echo.
echo [2/3] Dang sinh code tu dong cho Isar va Riverpod...
echo Buoc nay co the mat vai phut...
call flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo [3/3] Hoan tat!
echo.
echo ==================================================
echo      CAI DAT THANH CONG!
echo      De chay app, hay go: flutter run
echo ==================================================
pause
