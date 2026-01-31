# 🚀 Guía de Instalación de Flutter

## Paso 1: Descargar Flutter

1. **Ve a:** https://docs.flutter.dev/get-started/install/windows
2. **Descarga:** Flutter SDK para Windows (archivo .zip)
3. **Tamaño:** Aproximadamente 1.5 GB

## Paso 2: Extraer Flutter

1. **Crea la carpeta:** `C:\flutter`
2. **Extrae** el contenido del ZIP en `C:\flutter`
3. **Resultado:** Deberías tener `C:\flutter\bin\flutter.bat`

## Paso 3: Agregar al PATH

### Método Manual:
1. Presiona `Win + R`, escribe `sysdm.cpl`
2. Ve a "Opciones avanzadas" → "Variables de entorno"
3. En "Variables del usuario", selecciona "Path" → "Editar"
4. Agrega: `C:\flutter\bin`
5. Presiona "Aceptar" en todas las ventanas

### Método PowerShell (ejecuta esto):
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", [EnvironmentVariableTarget]::User)
```

## Paso 4: Reiniciar Terminal

1. **Cierra** PowerShell/CMD completamente
2. **Abre** una nueva ventana de PowerShell
3. **Ejecuta:** `flutter --version`

## Paso 5: Instalar Android Studio (Opcional pero recomendado)

1. **Descarga:** https://developer.android.com/studio
2. **Instala** Android Studio
3. **Abre** Android Studio y configura el SDK

## Paso 6: Verificar Instalación

```bash
flutter doctor
```

## Paso 7: Compilar tu App

```bash
cd C:\Users\User\Desktop\apk
flutter pub get
flutter build apk --release
```

## 🎯 Resultado Final

Tu APK estará en:
```
build\app\outputs\flutter-apk\app-release.apk
```

## ⚠️ Problemas Comunes

### "flutter no se reconoce"
- Reinicia la terminal después de agregar al PATH
- Verifica que `C:\flutter\bin\flutter.bat` existe

### "Android SDK not found"
- Instala Android Studio
- O ejecuta: `flutter doctor --android-licenses`

### Errores de compilación
- Ejecuta: `flutter clean` y luego `flutter pub get`

## 🚀 Alternativa Rápida

Si no quieres instalar Flutter ahora, puedes:
1. Usar el preview web (`preview_web.html`)
2. Subir el código a GitHub y usar GitHub Actions para compilar