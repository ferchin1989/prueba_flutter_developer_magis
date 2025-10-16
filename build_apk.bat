@echo off
echo Limpiando proyecto...
flutter clean

echo Obteniendo dependencias...
flutter pub get

echo Construyendo APK...
flutter build apk --release

echo APK generado en build\app\outputs\flutter-apk\app-release.apk
explorer build\app\outputs\flutter-apk\
