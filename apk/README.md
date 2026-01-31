# Descargador de Videos - Flutter App

Una aplicación móvil Flutter para descargar videos de YouTube, TikTok y Facebook.

## Características

- 📺 Descarga videos de YouTube
- 🎵 Descarga videos de TikTok  
- 📘 Descarga videos de Facebook
- 📱 Interfaz moderna y fácil de usar
- 📂 Gestión de archivos descargados
- 🔗 Detección automática de plataforma por URL

## Instalación

### Prerrequisitos

1. **Flutter SDK**: Descarga desde https://flutter.dev/docs/get-started/install
2. **Android Studio** o **VS Code** con extensiones de Flutter
3. **Dispositivo Android** o **Emulador** configurado

### Pasos de instalación

```bash
# Clonar o descargar el proyecto
cd descargador-videos-flutter

# Instalar dependencias
flutter pub get

# Verificar configuración
flutter doctor

# Ejecutar en dispositivo/emulador
flutter run
```

## Uso

1. **Abrir la aplicación**
2. **Copiar URL** del video desde YouTube, TikTok o Facebook
3. **Pegar la URL** en el campo de texto
4. **Presionar "Descargar Video"**
5. **Esperar** a que termine la descarga
6. **Ver descargas** en la sección "Mis Descargas"

## Plataformas Soportadas

| Plataforma | Estado | Formatos |
|------------|--------|----------|
| YouTube    | ✅ Soportado | MP4 |
| TikTok     | ✅ Soportado | MP4 |
| Facebook   | ✅ Soportado | MP4 |

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── screens/
│   ├── home_screen.dart        # Pantalla principal
│   └── downloads_screen.dart   # Pantalla de descargas
└── services/
    └── video_downloader_service.dart # Lógica de descarga
```

## Dependencias Principales

- `http`: Para peticiones HTTP
- `dio`: Cliente HTTP avanzado para descargas
- `path_provider`: Acceso a directorios del sistema
- `permission_handler`: Manejo de permisos
- `url_launcher`: Abrir URLs externas

## Permisos Requeridos

### Android
- `INTERNET`: Para descargar videos
- `WRITE_EXTERNAL_STORAGE`: Para guardar archivos
- `READ_EXTERNAL_STORAGE`: Para leer archivos descargados

## Compilación

### Debug
```bash
flutter run
```

### Release (Android)
```bash
flutter build apk --release
```

### Release (iOS)
```bash
flutter build ios --release
```

## Notas Importantes

- **APIs Externas**: La app usa APIs públicas que pueden cambiar
- **Términos de Servicio**: Respeta los términos de cada plataforma
- **Uso Personal**: Diseñado para uso personal y educativo
- **Calidad**: Los videos se descargan en la mejor calidad disponible

## Solución de Problemas

### Error de permisos
- Verificar permisos en configuración del dispositivo
- Reinstalar la aplicación si es necesario

### Error de descarga
- Verificar conexión a internet
- Comprobar que la URL sea válida
- Intentar con otra URL

### Espacio insuficiente
- Liberar espacio en el dispositivo
- Eliminar descargas antiguas desde la app

## Contribuir

1. Fork el proyecto
2. Crear rama para nueva característica
3. Commit los cambios
4. Push a la rama
5. Crear Pull Request

## Licencia

Este proyecto es de código abierto para fines educativos.