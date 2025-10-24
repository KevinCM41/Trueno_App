# 🗺️ Configuración de Google Maps para Trueno App

## 📋 Pasos para configurar Google Maps API

### 1. **Obtener API Key de Google Maps**

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Ve a "APIs & Services" > "Library"
4. Busca y habilita estas APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS** (si planeas compilar para iOS)
   - **Geocoding API** (opcional, para búsquedas de direcciones)

5. Ve a "APIs & Services" > "Credentials"
6. Haz clic en "Create Credentials" > "API Key"
7. Copia la API Key generada

### 2. **Configurar la API Key en el proyecto**

#### **Para Android:**
Edita el archivo `android/app/src/main/AndroidManifest.xml` y reemplaza `YOUR_API_KEY_HERE` con tu API Key real:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI" />
```

#### **Para iOS (opcional):**
Edita el archivo `ios/Runner/AppDelegate.swift` y agrega:

```swift
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("TU_API_KEY_AQUI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 3. **Restricciones de API Key (Recomendado para producción)**

Para proyectos de producción, restringe tu API Key:

1. En Google Cloud Console, ve a "Credentials"
2. Edita tu API Key
3. En "Application restrictions", selecciona "Android apps"
4. Agrega el package name: `com.example.trueno_home`
5. Agrega el SHA-1 fingerprint de tu certificado de debug/release

### 4. **Para uso educativo/prototipo**

Google ofrece $200 USD de crédito mensual gratuito, lo cual es más que suficiente para un prototipo universitario.

## 🚀 **Funcionalidades implementadas**

✅ **Mapa interactivo**: Google Maps con controles táctiles
✅ **Ubicación actual**: Detecta y muestra la posición del usuario
✅ **Marcadores**: Muestra conductores cercanos con información
✅ **Tema oscuro**: Estilo personalizado que combina con la app
✅ **Vista completa**: Modal de mapa en pantalla completa
✅ **Permisos**: Manejo automático de permisos de ubicación

## 🎯 **Datos de ejemplo**

El mapa incluye marcadores de ejemplo que corresponden a los conductores de la lista:
- **Javier Fernandez** (20m)
- **Miguel Ballesteros** (27m) 
- **Alberto Ruiz** (12m)
- **Alex Martinez** (7m)

## ⚠️ **Notas importantes**

1. **Sin API Key**: El mapa mostrará "For development purposes only"
2. **Ubicación por defecto**: Bogotá, Colombia (4.7110, -74.0721)
3. **Permisos**: La app solicitará permisos de ubicación automáticamente
4. **Testing**: Funciona en emulador y dispositivo físico

## 🔧 **Alternativa sin API Key**

Si no quieres configurar Google Maps API ahora, el mapa mostrará una marca de agua pero funcionará perfectamente para demostrar el prototipo.

## 📱 **Comandos para probar**

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Android
flutter run

# Construir APK para demo
flutter build apk --debug
```

¡Tu mapa estará listo para usar! 🎉
