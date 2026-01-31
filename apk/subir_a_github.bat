@echo off
echo ========================================
echo    PREPARANDO PROYECTO PARA GITHUB
echo ========================================
echo.

echo Creando archivo .gitignore...
echo # Miscellaneous > .gitignore
echo *.class >> .gitignore
echo *.log >> .gitignore
echo *.pyc >> .gitignore
echo *.swp >> .gitignore
echo .DS_Store >> .gitignore
echo .atom/ >> .gitignore
echo .buildlog/ >> .gitignore
echo .history >> .gitignore
echo .svn/ >> .gitignore
echo migrate_working_dir/ >> .gitignore
echo. >> .gitignore
echo # IntelliJ related >> .gitignore
echo *.iml >> .gitignore
echo *.ipr >> .gitignore
echo *.iws >> .gitignore
echo .idea/ >> .gitignore
echo. >> .gitignore
echo # Flutter/Dart/Pub related >> .gitignore
echo **/doc/api/ >> .gitignore
echo **/ios/Flutter/.last_build_id >> .gitignore
echo .dart_tool/ >> .gitignore
echo .flutter-plugins >> .gitignore
echo .flutter-plugins-dependencies >> .gitignore
echo .packages >> .gitignore
echo .pub-cache/ >> .gitignore
echo .pub/ >> .gitignore
echo /build/ >> .gitignore
echo. >> .gitignore
echo # Android related >> .gitignore
echo **/android/**/gradle-wrapper.jar >> .gitignore
echo **/android/.gradle >> .gitignore
echo **/android/captures/ >> .gitignore
echo **/android/gradlew >> .gitignore
echo **/android/gradlew.bat >> .gitignore
echo **/android/local.properties >> .gitignore
echo **/android/**/GeneratedPluginRegistrant.java >> .gitignore

echo.
echo ========================================
echo    ARCHIVOS LISTOS PARA SUBIR
echo ========================================
echo.
echo Ahora sigue estos pasos:
echo.
echo 1. Ve a tu repositorio en GitHub
echo 2. Haz clic en "uploading an existing file"
echo 3. Arrastra TODOS los archivos de esta carpeta
echo 4. Escribe: "Primera versión de la app"
echo 5. Haz clic en "Commit changes"
echo.
echo GitHub compilará automáticamente tu APK!
echo.
pause