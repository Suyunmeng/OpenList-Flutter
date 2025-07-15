#!/bin/bash

# iOS自动化构建脚本
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查环境
check_environment() {
    print_message "检查构建环境..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS构建需要macOS环境"
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        print_error "未找到Flutter，请先安装Flutter SDK"
        exit 1
    fi
    
    if ! command -v xcodebuild &> /dev/null; then
        print_error "未找到Xcode，请先安装Xcode"
        exit 1
    fi
    
    print_message "环境检查通过"
}

# 清理和准备
prepare_build() {
    print_message "准备构建环境..."
    
    # Flutter清理
    flutter clean
    
    # 获取依赖
    flutter pub get
    
    # 安装iOS依赖
    cd ios
    pod install
    cd ..
    
    print_message "构建环境准备完成"
}

# 构建函数
build_ios() {
    local build_mode=$1
    local codesign=$2
    
    print_message "开始构建iOS应用 (模式: $build_mode, 代码签名: $codesign)"
    
    if [ "$codesign" = "true" ]; then
        if [ "$build_mode" = "debug" ]; then
            flutter build ios --debug
        else
            flutter build ios --release
        fi
    else
        if [ "$build_mode" = "debug" ]; then
            flutter build ios --debug --no-codesign
        else
            flutter build ios --release --no-codesign
        fi
    fi
    
    print_message "Flutter构建完成"
}

# Archive和导出IPA
archive_and_export() {
    local export_method=$1
    
    print_message "开始Archive..."
    
    # 创建构建目录
    mkdir -p build
    
    # Archive
    xcodebuild -workspace ios/Runner.xcworkspace \
               -scheme Runner \
               -configuration Release \
               -destination generic/platform=iOS \
               -archivePath build/Runner.xcarchive \
               archive
    
    print_message "Archive完成"
    
    # 选择导出选项
    local export_options="ios/ExportOptions.plist"
    if [ "$export_method" = "appstore" ]; then
        export_options="ios/ExportOptions-AppStore.plist"
    fi
    
    print_message "导出IPA (方法: $export_method)..."
    
    # 导出IPA
    xcodebuild -exportArchive \
               -archivePath build/Runner.xcarchive \
               -exportPath build/ios_export \
               -exportOptionsPlist $export_options
    
    print_message "IPA导出完成: build/ios_export/"
}

# 显示帮助
show_help() {
    echo "iOS构建脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -m, --mode MODE        构建模式 (debug|release) [默认: release]"
    echo "  -s, --sign             启用代码签名"
    echo "  -a, --archive          Archive并导出IPA"
    echo "  -e, --export METHOD    导出方法 (development|appstore) [默认: development]"
    echo "  -h, --help             显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                     # 构建release版本，无代码签名"
    echo "  $0 -m debug            # 构建debug版本"
    echo "  $0 -s                  # 构建release版本，带代码签名"
    echo "  $0 -s -a               # 构建、Archive并导出开发版IPA"
    echo "  $0 -s -a -e appstore   # 构建、Archive并导出App Store版IPA"
}

# 主函数
main() {
    local build_mode="release"
    local codesign="false"
    local archive="false"
    local export_method="development"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--mode)
                build_mode="$2"
                shift 2
                ;;
            -s|--sign)
                codesign="true"
                shift
                ;;
            -a|--archive)
                archive="true"
                shift
                ;;
            -e|--export)
                export_method="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 验证参数
    if [[ "$build_mode" != "debug" && "$build_mode" != "release" ]]; then
        print_error "无效的构建模式: $build_mode"
        exit 1
    fi
    
    if [[ "$export_method" != "development" && "$export_method" != "appstore" ]]; then
        print_error "无效的导出方法: $export_method"
        exit 1
    fi
    
    if [[ "$archive" = "true" && "$codesign" = "false" ]]; then
        print_warning "Archive需要代码签名，自动启用代码签名"
        codesign="true"
    fi
    
    # 执行构建流程
    check_environment
    prepare_build
    build_ios "$build_mode" "$codesign"
    
    if [ "$archive" = "true" ]; then
        archive_and_export "$export_method"
    fi
    
    print_message "构建完成!"
    
    # 显示结果
    if [ "$archive" = "true" ]; then
        echo ""
        print_message "构建产物:"
        echo "  Archive: build/Runner.xcarchive"
        echo "  IPA: build/ios_export/"
        ls -la build/ios_export/
    else
        echo ""
        print_message "构建产物:"
        echo "  App: build/ios/iphoneos/Runner.app"
    fi
}

# 运行主函数
main "$@"