#!/bin/sh

cd $(dirname "$0")/..

VERSION=$(grep --color=never -Po "^version: \K.*" pubspec.yaml || true)
echo "-$VERSION-"

mkdir release
rm release/* -rf

echo "build for Android"
flutter build apk
cp build/app/outputs/flutter-apk/app-release.apk release/map-test-$VERSION-android.apk

echo "build for Windows"
flutter build windows

mkdir release/map-test-$VERSION-win
cp build/windows/runner/Release/* release/map-test-$VERSION-win/ -r
cd release
powershell Compress-Archive map-test-$VERSION-win map-test-$VERSION-win.zip
# tar -a -c -f map-test-$VERSION.zip map-test-$VERSION
rm map-test-$VERSION-win -rf