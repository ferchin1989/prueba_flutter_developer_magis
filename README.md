# TMDb Movies App

Aplicación móvil desarrollada con Flutter que consume la API de TMDb para mostrar información sobre películas.

## Características

- **Próximos estrenos**: Muestra las películas que se estrenarán próximamente.
- **Tendencia**: Muestra las películas que están en tendencia actualmente.
- **Recomendados para ti**: Sección personalizable con filtros por idioma y año de lanzamiento.
- **Detalles de película**: Información detallada de cada película, incluyendo:
  - Título
  - Descripción
  - Fecha de estreno
  - Imagen
  - Puntuación
  - Géneros
  - Opción para ver el tráiler
- **Caché offline**: La aplicación almacena datos para funcionar sin conexión.
- **Animaciones y transiciones**: Experiencia de usuario mejorada con animaciones.

## Arquitectura

El proyecto sigue una arquitectura limpia (Clean Architecture) con las siguientes capas:

- **Presentación**: UI y gestión de estado con BLoC.
- **Dominio**: Lógica de negocio y casos de uso.
- **Datos**: Repositorios y fuentes de datos (API y almacenamiento local).
- **Core**: Componentes compartidos y utilidades.

## Tecnologías utilizadas

- Flutter y Dart
- BLoC para gestión de estado
- Dio para peticiones HTTP
- Hive para almacenamiento local
- Cached Network Image para carga y caché de imágenes
- YouTube Player para reproducción de trailers
- Pruebas unitarias con Mockito

## Configuración

1. Clona el repositorio
2. Ejecuta `flutter pub get` para instalar las dependencias
3. Crea un archivo `.env` en la raíz del proyecto con la siguiente estructura:
   ```
   TMDB_API_KEY=tu_api_key_aquí
   TMDB_BASE_URL=https://api.themoviedb.org/3
   TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/
   ```
4. Ejecuta la aplicación con `flutter run`

## Capturas de pantalla

[Aquí se incluirían capturas de pantalla de la aplicación]

## Pruebas

Para ejecutar las pruebas unitarias:

```
flutter test
```
