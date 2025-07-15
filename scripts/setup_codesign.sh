#!/bin/bash

# iOS代码签名配置脚本
echo "iOS代码签名配置向导"
echo "===================="

# 检查是否在macOS上运行
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "错误: iOS代码签名只能在macOS上配置"
    exit 1
fi

# 检查Xcode是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "错误: 未找到Xcode，请先安装Xcode"
    exit 1
fi

echo ""
echo "请选择代码签名方式:"
echo "1. 自动签名 (推荐用于开发)"
echo "2. 手动签名 (用于发布)"
echo "3. 查看当前签名配置"
echo "4. 查看可用的开发者证书"
echo "5. 查看可用的Provisioning Profiles"

read -p "请输入选择 (1-5): " choice

case $choice in
    1)
        echo ""
        echo "配置自动签名..."
        echo "请确保:"
        echo "1. 已登录Apple Developer账号到Xcode"
        echo "2. 在Xcode中选择了正确的Team"
        echo ""
        echo "在Xcode中打开项目: open ios/Runner.xcworkspace"
        echo "然后在项目设置中启用'Automatically manage signing'"
        ;;
    2)
        echo ""
        echo "配置手动签名..."
        echo "请提供以下信息:"
        read -p "Team ID: " team_id
        read -p "开发证书名称 (如: iPhone Developer): " dev_cert
        read -p "发布证书名称 (如: iPhone Distribution): " dist_cert
        read -p "Provisioning Profile名称: " profile_name
        
        # 更新ExportOptions.plist
        sed -i '' "s/YOUR_TEAM_ID/$team_id/g" ios/ExportOptions.plist
        sed -i '' "s/YOUR_PROVISIONING_PROFILE_NAME/$profile_name/g" ios/ExportOptions.plist
        sed -i '' "s/iPhone Developer/$dev_cert/g" ios/ExportOptions.plist
        
        sed -i '' "s/YOUR_TEAM_ID/$team_id/g" ios/ExportOptions-AppStore.plist
        sed -i '' "s/YOUR_APPSTORE_PROVISIONING_PROFILE_NAME/$profile_name/g" ios/ExportOptions-AppStore.plist
        sed -i '' "s/iPhone Distribution/$dist_cert/g" ios/ExportOptions-AppStore.plist
        
        echo "配置已更新到ExportOptions.plist文件"
        ;;
    3)
        echo ""
        echo "当前签名配置:"
        if [ -f "ios/Runner.xcworkspace" ]; then
            xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner | grep -E "(CODE_SIGN|PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM)"
        else
            echo "未找到Xcode workspace文件"
        fi
        ;;
    4)
        echo ""
        echo "可用的开发者证书:"
        security find-identity -v -p codesigning
        ;;
    5)
        echo ""
        echo "可用的Provisioning Profiles:"
        ls -la ~/Library/MobileDevice/Provisioning\ Profiles/
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo ""
echo "代码签名配置完成!"
echo ""
echo "构建命令:"
echo "开发版本: flutter build ios --debug"
echo "发布版本: flutter build ios --release"
echo "带签名的发布版本: flutter build ios --release --codesign"
echo ""
echo "Archive命令:"
echo "xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS -archivePath build/Runner.xcarchive archive"
echo ""
echo "导出IPA:"
echo "xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportPath build/ios_export -exportOptionsPlist ios/ExportOptions.plist"