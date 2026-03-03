//
//  HydroTrackApp.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import SwiftUI

@main
struct HydroTrackApp: App {
    @StateObject private var waterManager = WaterManager()
    @StateObject private var reminderManager = ReminderManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waterManager)
                .environmentObject(reminderManager)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // 请求通知权限
        reminderManager.requestAuthorization()
        
        // 设置提醒
        reminderManager.scheduleReminders()
        
        // 加载今日数据
        waterManager.loadTodayData()
    }
}
