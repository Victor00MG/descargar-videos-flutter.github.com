@echo off
echo ========================================
echo    COMPILADOR DE APK - DESCARGADOR DE VIDEOS
echo ========================================
echo.

echo Verificando Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter no está instalado o no está en el PATH
    echo.
    echo Para instalar Flutter:
    echo 1. Ve a https://flutter.dev/docs/get-started/install/windows
    echo 2. Descarga el SDK
    echo 3. Extrae en C:\flutter
    echo 4. Agrega C:\flutter\bin al PATH
    echo.
    pause
    exit /b 1
)

echo.
echo Obteniendo dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: No se pudieron obtener las dependencias
    pause
    exit /b 1
)

echo.
echo Analizando código...
flutter analyze

echo.
echo Compilando APK de release...
flutter build apk --release --build-name=1.0.0
if %errorlevel% neq 0 (
    echo ERROR: No se pudo compilar el APK
    pause
    exit /b 1
)

echo.
echo ========================================
echo    ¡COMPILACIÓN EXITOSA!
echo ========================================
echo.
echo El APK se encuentra en:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Para instalar en tu móvil:
echo 1. Habilita "Fuentes desconocidas" en tu Android
echo 2. Transfiere el APK a tu móvil
echo 3. Instala el APK
echo.
pause