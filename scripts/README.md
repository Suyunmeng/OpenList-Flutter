# iOS构建脚本说明

本目录包含iOS构建和代码签名相关的脚本。

## 脚本列表

### setup_ios.sh / setup_ios.bat
iOS开发环境设置脚本
- macOS版本：`setup_ios.sh`
- Windows参考版本：`setup_ios.bat`

**用法：**
```bash
chmod +x setup_ios.sh
./setup_ios.sh
```

### setup_codesign.sh
iOS代码签名配置脚本

**用法：**
```bash
chmod +x setup_codesign.sh
./setup_codesign.sh
```

**功能：**
- 配置自动签名
- 配置手动签名
- 查看签名配置
- 查看可用证书
- 查看Provisioning Profiles

### build_ios.sh
iOS自动化构建脚本

**用法：**
```bash
chmod +x build_ios.sh

# 基本构建 (无签名)
./build_ios.sh

# 带签名构建
./build_ios.sh --sign

# Archive并导出IPA
./build_ios.sh --sign --archive

# 导出App Store版本
./build_ios.sh --sign --archive --export appstore

# 查看帮助
./build_ios.sh --help
```

## 使用前准备

1. 确保在macOS环境下运行
2. 安装Xcode和Flutter SDK
3. 安装CocoaPods
4. 给脚本添加执行权限：
   ```bash
   chmod +x *.sh
   ```

## 代码签名要求

- **开发测试**：需要开发者证书和开发Provisioning Profile
- **App Store发布**：需要发布证书和App Store Provisioning Profile
- **企业分发**：需要企业证书和企业Provisioning Profile

详细配置请参考：[iOS代码签名指南](../docs/iOS_CodeSigning.md)