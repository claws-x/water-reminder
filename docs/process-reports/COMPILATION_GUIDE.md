# HydroTrack 编译指南

**项目**: HydroTrack  
**版本**: v1.0  
**日期**: 2026-03-03

---

## 🚀 快速编译

### 前提条件

1. **macOS** 13.0+
2. **Xcode** 15.0+ (从 App Store 安装)
3. **Apple ID** (用于代码签名)

---

## 📱 方法 1: Xcode (最简单)

```bash
# 1. 打开工程
open /Users/aiagent_master/.openclaw/workspace-sub3/src/ios/HydroTrack.xcodeproj

# 2. 在 Xcode 中:
#    - 选择 "HydroTrack" 项目
#    - 选择 "Signing & Capabilities" 标签
#    - 在 "Team" 下拉菜单中选择你的开发团队
#      (如无，点击 "Add an Account..." 添加 Apple ID)
#    - 选择目标设备：iPhone 15 (或你的真机)
#    - 点击运行按钮 (▶️) 或按 ⌘R

# 3. 等待编译完成，模拟器会自动启动 App
```

---

## 💻 方法 2: 命令行

```bash
cd /Users/aiagent_master/.openclaw/workspace-sub3/src/ios

# Debug 编译 (模拟器)
xcodebuild -scheme HydroTrack \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           clean build

# Release 编译 (真机)
xcodebuild -scheme HydroTrack \
           -configuration Release \
           -destination 'generic/platform=iOS' \
           clean build
```

---

## 🧪 运行测试

```bash
cd /Users/aiagent_master/.openclaw/workspace-sub3/src/ios

# 运行所有测试
xcodebuild test -scheme HydroTrack \
                -destination 'platform=iOS Simulator,name=iPhone 15'

# 或使用脚本 (如已创建)
../../tools/run_tests_ios.sh
```

---

## ⚙️ 代码签名

### 自动签名 (推荐)

1. 打开 Xcode
2. 选择项目 → Signing & Capabilities
3. 勾选 "Automatically manage signing"
4. 选择开发团队

### 手动签名

1. 在 [Apple Developer](https://developer.apple.com) 创建证书
2. 下载并安装证书
3. 在 Xcode 中手动选择证书

---

## 🐛 故障排查

### 问题 1: 编译失败

```
error: Swift compiler error
```

**解决**:
```bash
# 清理构建缓存
rm -rf ~/Library/Developer/Xcode/DerivedData/HydroTrack-*

# 重新编译
xcodebuild clean build
```

### 问题 2: 签名错误

```
No signing certificate found
```

**解决**:
1. 打开 Xcode → Preferences → Accounts
2. 添加 Apple ID
3. 重新选择开发团队

### 问题 3: 模拟器不可用

```
Unable to find a destination matching the provided destination specifier
```

**解决**:
```bash
# 列出可用模拟器
xcrun simctl list devices available

# 运行时选择可用设备
xcodebuild -scheme HydroTrack \
           -destination 'platform=iOS Simulator,name=iPhone 14,OS=17.0'
```

---

## 📊 编译输出

### 成功

```
** BUILD SUCCEEDED **
```

### 失败

```
** BUILD FAILED **

查看错误信息，通常是:
- 语法错误
- 缺少依赖
- 签名问题
```

---

## 📝 下一步

编译成功后:

1. **模拟器测试** - 在模拟器中体验 App
2. **真机测试** - 连接 iPhone 测试
3. **性能测试** - 使用 Instruments 分析
4. **准备发布** - 打包 Archive

---

## 🎯 功能测试清单

### 核心功能

- [ ] 打开 App，查看进度圆环
- [ ] 点击快速添加按钮，记录喝水
- [ ] 进度圆环更新
- [ ] 切换到统计页面，查看图表
- [ ] 切换到设置页面，修改目标
- [ ] 设置提醒，检查通知权限

### 界面测试

- [ ] 所有按钮可点击
- [ ] 文字清晰可读
- [ ] 图标显示正常
- [ ] 滚动流畅

### 性能测试

- [ ] 启动时间 < 1 秒
- [ ] 切换页面无卡顿
- [ ] 内存占用 < 80MB

---

**文档状态**: ✅ 已完成  
**适用版本**: v1.0 MVP
