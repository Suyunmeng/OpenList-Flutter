#!/bin/bash

# iOS Setup Script for OpenList Flutter
echo "Setting up iOS development environment..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: iOS development requires macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "Cleaning Flutter project..."
flutter clean

echo "Getting Flutter dependencies..."
flutter pub get

echo "Installing iOS dependencies..."
cd ios
pod install
cd ..

echo "Checking Flutter doctor for iOS..."
flutter doctor

echo "iOS setup completed!"
echo ""
echo "To build for iOS:"
echo "  Debug: flutter build ios --debug"
echo "  Release: flutter build ios --release"
echo ""
echo "To run on iOS simulator:"
echo "  flutter run -d ios"
echo ""
echo "To open in Xcode:"
echo "  open ios/Runner.xcworkspace"