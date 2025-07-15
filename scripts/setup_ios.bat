@echo off
echo iOS Setup Script for OpenList Flutter
echo.

echo Note: iOS development requires macOS with Xcode installed.
echo This script is for reference only on Windows.
echo.

echo To set up iOS development:
echo 1. Use a macOS machine or macOS virtual machine
echo 2. Install Xcode from the App Store
echo 3. Install CocoaPods: sudo gem install cocoapods
echo 4. Run: flutter clean
echo 5. Run: flutter pub get
echo 6. Run: cd ios && pod install
echo 7. Run: flutter doctor
echo.

echo To build for iOS:
echo   Debug: flutter build ios --debug
echo   Release: flutter build ios --release
echo.

echo To run on iOS simulator:
echo   flutter run -d ios
echo.

echo To open in Xcode:
echo   open ios/Runner.xcworkspace

pause