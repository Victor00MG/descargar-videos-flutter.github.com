# 🚀 Instrucciones para Compilar tu APK con GitHub

## Paso 1: Crear Repositorio en GitHub

1. **Ve a:** https://github.com
2. **Inicia sesión** o crea una cuenta
3. **Haz clic en:** "New repository" (botón verde)
4. **Nombre:** `descargador-videos-flutter`
5. **Descripción:** `Aplicación móvil para descargar videos de YouTube, TikTok y Facebook`
6. **Selecciona:** Public
7. **NO marques** "Add a README file"
8. **Haz clic en:** "Create repository"

## Paso 2: Subir Archivos

1. **En la página del repositorio**, haz clic en "uploading an existing file"
2. **Arrastra TODOS los archivos** de tu carpeta `C:\Users\User\Desktop\apk`
3. **O haz clic en "choose your files"** y selecciona todos
4. **Mensaje del commit:** "Primera versión - Descargador de Videos"
5. **Haz clic en:** "Commit changes"

## Paso 3: Activar GitHub Actions

1. **Ve a la pestaña "Actions"** en tu repositorio
2. **GitHub detectará automáticamente** el archivo de workflow
3. **Haz clic en "I understand my workflows, go ahead and enable them"**

## Paso 4: Compilar APK

1. **Ve a "Actions"** → **"Build Flutter APK"**
2. **Haz clic en "Run workflow"** → **"Run workflow"**
3. **Espera 5-10 minutos** mientras GitHub compila tu app
4. **Cuando termine**, verás una marca verde ✅

## Paso 5: Descargar APK

1. **Haz clic en el workflow completado**
2. **En "Artifacts"**, haz clic en **"release-apk"**
3. **Se descargará un ZIP** con tu APK
4. **Extrae el archivo** `app-release.apk`

## Paso 6: Instalar en tu Móvil

1. **En tu Android**, ve a Configuración → Seguridad
2. **Habilita "Fuentes desconocidas"** o "Instalar apps desconocidas"
3. **Transfiere el APK** a tu móvil (USB, email, etc.)
4. **Toca el archivo APK** para instalarlo
5. **¡Disfruta tu app!** 🎉

## 🔄 Para Futuras Actualizaciones

1. **Modifica los archivos** en GitHub directamente
2. **O sube nuevos archivos** reemplazando los existentes
3. **GitHub compilará automáticamente** cada vez que hagas cambios

## ⚠️ Notas Importantes

- **La primera compilación** puede tardar 10-15 minutos
- **Las siguientes** serán más rápidas (5-8 minutos)
- **El APK final** tendrá aproximadamente 20-30 MB
- **Funciona en Android 5.0+** (API 21+)

## 🆘 Si Algo Sale Mal

1. **Ve a "Actions"** y revisa los logs de error
2. **O contacta conmigo** para ayudarte a solucionarlo

¡Tu app estará lista para usar en tu móvil! 📱