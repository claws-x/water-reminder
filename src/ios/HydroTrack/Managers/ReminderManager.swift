//
//  ReminderManager.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import Foundation
import UserNotifications

/// 提醒管理器
class ReminderManager: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var isEnabled: Bool = true
    @Published var reminderInterval: Int = 60  // 分钟
    @Published var quietStart: Date = Date()
    @Published var quietEnd: Date = Date()
    
    // MARK: - Constants
    private let enabledKey = "reminder_enabled"
    private let intervalKey = "reminder_interval"
    private let quietStartKey = "quiet_start"
    private let quietEndKey = "quiet_end"
    
    // MARK: - Initialization
    override init() {
        super.init()
        loadSettings()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ 通知权限已获取")
                } else {
                    print("❌ 通知权限被拒绝")
                }
            }
        }
    }
    
    // MARK: - Schedule Reminders
    func scheduleReminders() {
        guard isEnabled else {
            cancelAllReminders()
            return
        }
        
        // 取消现有提醒
        cancelAllReminders()
        
        // 创建提醒
        let content = UNMutableNotificationContent()
        content.title = "💧 该喝水了！"
        content.body = "保持水分充足，让身体更健康～"
        content.sound = .default
        content.categoryIdentifier = "water_reminder"
        
        // 每小时间隔推送
        var components = DateComponents()
        components.minute = 0
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(reminderInterval * 60),
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "water_reminder_1",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 设置提醒失败：\(error.localizedDescription)")
            } else {
                print("✅ 喝水提醒已设置：每 \(self.reminderInterval) 分钟")
            }
        }
    }
    
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ 已取消所有提醒")
    }
    
    // MARK: - Settings
    func updateInterval(_ minutes: Int) {
        reminderInterval = minutes
        UserDefaults.standard.set(minutes, forKey: intervalKey)
        scheduleReminders()
    }
    
    func toggleEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: enabledKey)
        scheduleReminders()
    }
    
    private func loadSettings() {
        if let enabled = UserDefaults.standard.object(forKey: enabledKey) as? Bool {
            isEnabled = enabled
        }
        
        if let interval = UserDefaults.standard.object(forKey: intervalKey) as? Int {
            reminderInterval = interval
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension ReminderManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
