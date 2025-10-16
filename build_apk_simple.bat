@echo off
cd /d %~dp0
echo Limpiando proyecto...
flutter clean

echo Obteniendo dependencias...
flutter pub get

echo Construyendo APK...
flutter build apk --release --split-per-abi

echo APK generado en build\app\outputs\flutter-apk\
explorer build\app\outputs\flutter-apk\
