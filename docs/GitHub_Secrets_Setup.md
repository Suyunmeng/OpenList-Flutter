# GitHub Secrets配置指南

为了在GitHub Actions中进行iOS代码签名和发布，需要配置以下Secrets。

## iOS代码签名所需的Secrets

### 1. IOS_DIST_SIGNING_KEY
**描述**: iOS发布证书的P12文件（Base64编码）

**获取步骤**:
1. 在Keychain Access中导出发布证书为P12文件
2. 将P12文件转换为Base64编码：
   ```bash
   base64 -i YourCertificate.p12 | pbcopy
   ```
3. 将输出的Base64字符串添加到GitHub Secrets

### 2. IOS_DIST_SIGNING_KEY_PASSWORD
**描述**: P12证书文件的密码

**获取步骤**:
- 输入导出P12证书时设置的密码

### 3. APPSTORE_ISSUER_ID
**描述**: App Store Connect API的Issuer ID

**获取步骤**:
1. 登录 [App Store Connect](https://appstoreconnect.apple.com)
2. 进入 Users and Access → Keys
3. 复制 Issuer ID

### 4. APPSTORE_KEY_ID
**描述**: App Store Connect API Key的ID

**获取步骤**:
1. 在App Store Connect的Keys页面
2. 创建或选择一个API Key
3. 复制Key ID

### 5. APPSTORE_PRIVATE_KEY
**描述**: App Store Connect API的私钥内容

**获取步骤**:
1. 下载API Key的.p8文件
2. 将文件内容复制到Secrets中：
   ```bash
   cat AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```

## 配置步骤

### 1. 在GitHub仓库中添加Secrets

1. 进入GitHub仓库页面
2. 点击 Settings → Secrets and variables → Actions
3. 点击 "New repository secret"
4. 依次添加上述5个Secrets

### 2. 验证配置

配置完成后，可以通过以下方式验证：

1. **手动触发工作流**:
   - 进入Actions页面
   - 选择"Release"工作流
   - 点击"Run workflow"

2. **推送CHANGELOG.md**:
   - 修改CHANGELOG.md文件
   - 推送到master分支
   - 自动触发发布流程

## 证书和Profile管理

### 创建发布证书

1. 登录Apple Developer账号
2. 进入Certificates, Identifiers & Profiles
3. 创建iOS Distribution证书
4. 下载并安装到Keychain

### 创建App Store Provisioning Profile

1. 在Apple Developer中创建App Store类型的Provisioning Profile
2. 选择对应的App ID: `com.github.openlistteam.openlistFlutter`
3. 选择发布证书
4. 下载Profile文件

### 更新ExportOptions配置

确保 `ios/ExportOptions-AppStore.plist` 中的配置正确：

```xml
<key>teamID</key>
<string>YOUR_TEAM_ID</string>
<key>provisioningProfiles</key>
<dict>
    <key>com.github.openlistteam.openlistFlutter</key>
    <string>YOUR_PROVISIONING_PROFILE_NAME</string>
</dict>
```

## 常见问题

### 1. "No signing certificate found"
- 检查IOS_DIST_SIGNING_KEY是否正确
- 确认证书未过期
- 验证P12文件密码

### 2. "No provisioning profile found"
- 检查Bundle ID是否匹配
- 确认Provisioning Profile包含正确的证书
- 验证Profile未过期

### 3. "Invalid API Key"
- 检查APPSTORE_KEY_ID是否正确
- 确认API Key有足够权限
- 验证私钥格式正确

### 4. Base64编码问题
```bash
# macOS/Linux
base64 -i input.p12 -o output.txt

# 或者一行命令
base64 -i YourCertificate.p12 | tr -d '\n' | pbcopy
```

## 安全注意事项

1. **定期更新证书**: iOS证书有效期为1年
2. **限制API Key权限**: 只给予必要的权限
3. **定期轮换密钥**: 建议定期更新API Key
4. **监控使用情况**: 定期检查API Key使用日志

## 发布流程

配置完成后，发布流程如下：

1. 更新版本号（在Info.plist中）
2. 更新CHANGELOG.md
3. 推送到master分支
4. GitHub Actions自动构建Android APK和iOS IPA
5. 自动创建GitHub Release
6. 手动上传IPA到App Store Connect（如需要）

## 相���文件

- `ios/ExportOptions-AppStore.plist`: App Store导出配置
- `.github/workflows/release.yaml`: 发布工作流
- `docs/iOS_CodeSigning.md`: 详细的代码签名指南