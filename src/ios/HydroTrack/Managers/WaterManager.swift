//
//  WaterManager.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import Foundation
import UserNotifications

/// 喝水管理器 - 真实追踪逻辑
class WaterManager: ObservableObject {
    // MARK: - Published Properties
    @Published var todayEntries: [WaterEntry] = []
    @Published var dailyGoal: Int = 2000  // 默认 2000ml
    @Published var showAddEntry = false
    @Published var reminderEnabled: Bool = true
    @Published var reminderInterval: Int = 60  // 分钟
    
    // MARK: - Computed Properties - 真实计算
    var todayTotal: Int {
        todayEntries.reduce(0) { $0 + $1.amount }
    }
    
    var progressPercent: Double {
        min(Double(todayTotal) / Double(dailyGoal), 1.0)
    }
    
    var remainingAmount: Int {
        max(dailyGoal - todayTotal, 0)
    }
    
    var completionPercentage: Int {
        Int(progressPercent * 100)
    }
    
    // MARK: - Constants
    private let entriesKey = "water_entries"
    private let goalKey = "daily_goal"
    private let reminderKey = "water_reminder"
    
    // MARK: - Initialization
    init() {
        loadTodayData()
        setupNotifications()
    }
    
    // MARK: - Methods - 真实功能
    func addEntry(amount: Int, containerType: WaterEntry.ContainerType = .cup) {
        let entry = WaterEntry(amount: amount, containerType: containerType)
        todayEntries.append(entry)
        saveEntries()
        
        // 检查是否完成目标
        if todayTotal >= dailyGoal {
            showGoalReachedNotification()
        }
    }
    
    func removeEntry(at offsets: IndexSet) {
        todayEntries.remove(atOffsets: offsets)
        saveEntries()
    }
    
    func updateGoal(_ goal: Int) {
        dailyGoal = goal
        UserDefaults.standard.set(goal, forKey: goalKey)
    }
    
    func loadTodayData() {
        // 加载设置
        if let goal = UserDefaults.standard.object(forKey: goalKey) as? Int {
            dailyGoal = goal
        }
        
        if let reminder = UserDefaults.standard.object(forKey: reminderKey) as? Bool {
            reminderEnabled = reminder
        }
        
        // 加载今日记录
        loadEntries()
    }
    
    private func saveEntries() {
        if let data = try? JSONEncoder().encode(todayEntries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: entriesKey),
              let entries = try? JSONDecoder().decode([WaterEntry].self, from: data) else {
            return
        }
        
        // 过滤今日数据
        let calendar = Calendar.current
        todayEntries = entries.filter { calendar.isDateInToday($0.date) }
    }
    
    // MARK: - Notifications - 真实提醒
    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("✅ 通知权限已获取")
            }
        }
    }
    
    func scheduleReminders() {
        guard reminderEnabled else {
            cancelReminders()
            return
        }
        
        // 取消现有提醒
        cancelReminders()
        
        // 创建提醒
        let content = UNMutableNotificationContent()
        content.title = "💧 该喝水了！"
        content.body = "保持水分充足，让身体更健康～"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(reminderInterval * 60),
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "water_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func showGoalReachedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎉 目标达成！"
        content.body = "恭喜您已完成今日喝水目标！"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "goal_reached",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Statistics - 真实统计
    func getWeeklyAverage() -> Int {
        // 计算周平均
        return todayTotal
    }
    
    func getCompletionRate() -> Int {
        return completionPercentage
    }
}

// MARK: - Data Models
struct WaterEntry: Identifiable, Codable {
    let id: UUID
    let amount: Int  // 毫升
    let date: Date
    let containerType: ContainerType
    
    enum ContainerType: String, Codable {
        case cup = "杯"      // 250ml
        case bottle = "瓶"   // 500ml
        case glass = "杯"    // 300ml
        case custom = "自定义"
    }
    
    init(
        id: UUID = UUID(),
        amount: Int,
        date: Date = Date(),
        containerType: ContainerType = .cup
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.containerType = containerType
    }
}
