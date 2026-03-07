# HydroTrack 💧

> 喝水提醒 + 健康追踪 - 保持水分，保持健康

[![Platform](https://img.shields.io/badge/platform-iOS%2015.0+-blue.svg)](https://developer.apple.com/ios)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📱 应用简介

HydroTrack 是一款简约的喝水提醒和健康追踪应用，帮助您养成良好的饮水习惯，保持身体水分平衡，提升健康水平。

**定价**：$1.99（一次性购买，无订阅）

## ✨ 核心功能

### 💧 喝水记录
- 一键记录每次饮水量
- 支持自定义杯型容量
- 快速添加常用容量

### ⏰ 智能提醒
- 自定义提醒时间
- 智能间隔提醒
- 支持勿扰模式

### 📊 数据统计
- 每日进度可视化
- 周/月统计图表
- 饮水趋势分析

### 🏆 成就系统
- 连续打卡奖励
- 里程碑成就
- 健康目标达成

### 🎯 目标设置
- 自定义每日目标（4-12 杯）
- 智能推荐目标
- 根据体重/活动量调整

## 🛠️ 技术栈

| 技术 | 说明 |
|------|------|
| SwiftUI | 声明式 UI 框架 |
| UserDefaults | 本地数据存储 |
| UserNotifications | 本地推送通知 |
| Charts | 数据可视化 |

## 📦 项目结构

```
HydroTrack/
├── HydroTrackApp.swift
├── ContentView.swift
└── Assets.xcassets/
```

## 🚀 构建指南

### 环境要求
- macOS 13.0+
- Xcode 15.0+
- iOS 15.0+ SDK

### 构建步骤

```bash
# 1. 克隆仓库
git clone https://github.com/claws-x/water-reminder.git
cd water-reminder

# 2. 打开 Xcode 工程
open HydroTrack.xcodeproj

# 3. 构建并运行
xcodebuild -project HydroTrack.xcodeproj \
  -scheme HydroTrack \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

## 📸 截图

> 截图待添加

| 主界面 | 统计图表 | 目标设置 |
|--------|----------|----------|
| ![主界面](screenshots/home.png) | ![统计](screenshots/stats.png) | ![目标](screenshots/goal.png) |

## 📋 隐私说明

- **无数据收集**：本应用不收集任何用户数据
- **本地存储**：所有数据存储在本地
- **无网络请求**：无需联网即可使用
- **无第三方 SDK**：无广告、无追踪

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📬 联系方式

- GitHub: [@claws-x](https://github.com/claws-x)
- 问题反馈：[Issues](https://github.com/claws-x/water-reminder/issues)

---

**HydroTrack** - 每天喝够水，健康每一天 💧
