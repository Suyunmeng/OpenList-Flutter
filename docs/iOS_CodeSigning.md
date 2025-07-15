# iOS代码签名配置指南

## 概述

iOS应用需要代码签名才能在真机上运行和发布到App Store。本文档介绍如何配置代码签名。

## 代码签名类型

### 1. 开发签名 (Development)
- 用于在开发设备上测试
- 需要开发者证书和开发Provisioning Profile
- 设备需要注册到开发者账号

### 2. 发布签名 (Distribution)
- 用于App Store发布
- 需要发布证书和App Store Provisioning Profile

## 配置步骤

### 方法一：自动签名 (推荐)

1. 在Xcode中打开项目：
   ```bash
   open ios/Runner.xcworkspace
   ```

2. 选择Runner项目 → Signing & Capabilities

3. 勾选"Automatically manage signing"

4. 选择正确的Team (需要先在Xcode中登录Apple ID)

5. 确认Bundle Identifier: `com.github.openlistteam.openlistFlutter`

### 方法二：手动签名

1. 准备证书和Provisioning Profile：
   - 开发证书: iPhone Developer
   - 发布证书: iPhone Distribution  
   - 对应的Provisioning Profile

2. 运行配置脚本：
   ```bash
   chmod +x scripts/setup_codesign.sh
   ./scripts/setup_codesign.sh
   ```

3. 按提示输入Team ID、证书名称等信息

## 构建命令

### 本地构建

```bash
# 无代码签名 (仅用于模拟器)
flutter build ios --debug --no-codesign
flutter build ios --release --no-codesign

# 带代码签名
flutter build ios --debug
flutter build ios --release

# 使用自动化脚本
chmod +x scripts/build_ios.sh

# 基本构建
./scripts/build_ios.sh

# 带代码签名的构建
./scripts/build_ios.sh --sign

# Archive并导出IPA
./scripts/build_ios.sh --sign --archive

# 导出App Store版本
./scripts/build_ios.sh --sign --archive --export appstore
```

### GitHub Actions构建

#### 无代码签名构建 (默认)
- 推送代码到main/develop分支自动触发
- 生成未签名的.app文件

#### 带代码签名构建
1. 在GitHub仓库设置中添加Secrets：
   ```
   IOS_DIST_SIGNING_KEY: P12证书的Base64编码
   IOS_DIST_SIGNING_KEY_PASSWORD: P12证书密码
   APPSTORE_ISSUER_ID: App Store Connect API Issuer ID
   APPSTORE_KEY_ID: App Store Connect API Key ID  
   APPSTORE_PRIVATE_KEY: App Store Connect API私钥
   ```

2. 手动触发工作流：
   - 进入Actions页面
   - 选择"iOS Build"工作流
   - 点击"Run workflow"
   - 勾选"Enable code signing"

## 证书和Profile管理

### 查看可用证书
```bash
security find-identity -v -p codesigning
```

### 查看Provisioning Profiles
```bash
ls -la ~/Library/MobileDevice/Provisioning\ Profiles/
```

### 安装证书
```bash
# 双击.p12文件或使用命令行
security import certificate.p12 -k ~/Library/Keychains/login.keychain
```

## 常见问题

### 1. "No signing certificate found"
- 确保已安装开发者证书
- 检查证书是否过期
- 确认Team ID正确

### 2. "No provisioning profile found"
- 确保Provisioning Profile包含当前设备
- 检查Bundle ID是否匹配
- 确认Profile未过期

### 3. "Code signing is required for product type 'Application'"
- 必须启用代码签名才能构建真机版本
- 使用`--no-codesign`仅适用于模拟器

### 4. Archive失败
- 确保使用Release配置
- 检查所有依赖库都支持真机架构
- 确认代码签名配置正确

## 发布流程

### 1. 构建和Archive
```bash
./scripts/build_ios.sh --sign --archive --export appstore
```

### 2. 上传到App Store Connect
```bash
# 使用Xcode
open build/ios_export/

# 或使用命令行
xcrun altool --upload-app -f build/ios_export/Runner.ipa -u "your-apple-id" -p "app-specific-password"
```

### 3. 在App Store Connect中提交审核

## 注意事项

1. **Bundle ID**: 确保与Apple Developer账号中的App ID一致
2. **版本号**: 每次发布需要递增版本号
3. **权限**: 确保Info.plist中的权限描述准确
4. **测试**: 在真机上充分测试后再提交审核
5. **证书有效期**: 定期检查和更新证书

## 相关文件

- `ios/ExportOptions.plist`: 开发版导出配置
- `ios/ExportOptions-AppStore.plist`: App Store版导出配置
- `scripts/setup_codesign.sh`: 代码签名配置脚本
- `scripts/build_ios.sh`: 自动化构建脚本
- `.github/workflows/ios.yml`: GitHub Actions工作流