#!/bin/bash

cd ../openlistlib || exit

# Build for Android
if [ "$1" == "debug" ]; then
  gomobile bind -ldflags "-s -w" -v -androidapi 19 -target="android/arm64"
else
  gomobile bind -ldflags "-s -w" -v -androidapi 19
fi

echo "Moving aar and jar files to android/app/libs"
mkdir -p ../../android/app/libs
mv -f ./*.aar ../../android/app/libs
mv -f ./*.jar ../../android/app/libs

# Build for iOS
echo "Building for iOS..."
if [ "$1" == "debug" ]; then
  gomobile bind -ldflags "-s -w" -v -target="ios/arm64"
else
  gomobile bind -ldflags "-s -w" -v -target="ios"
fi

echo "Moving framework to ios/Runner"
mkdir -p ../../ios/Runner/Frameworks
mv -f ./*.xcframework ../../ios/Runner/Frameworks/ 2>/dev/null || true
mv -f ./*.framework ../../ios/Runner/Frameworks/ 2>/dev/null || true
