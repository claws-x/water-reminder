//
//  WaterManager.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import Foundation
import SwiftUI

/// 喝水记录模型
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

/// 喝水管理器
class WaterManager: ObservableObject {
    // MARK: - Published Properties
    @Published var todayEntries: [WaterEntry] = []
    @Published var dailyGoal: Int = 2000  // 默认 2000ml
    @Published var showAddEntry = false
    
    // MARK: - Computed Properties
    var todayTotal: Int {
        todayEntries.reduce(0) { $0 + $1.amount }
    }
    
    var progressPercent: Double {
        min(Double(todayTotal) / Double(dailyGoal), 1.0)
    }
    
    var remainingAmount: Int {
        max(dailyGoal - todayTotal, 0)
    }
    
    // MARK: - Constants
    private let entriesKey = "water_entries"
    private let goalKey = "daily_goal"
    
    // MARK: - Initialization
    init() {
        loadTodayData()
    }
    
    // MARK: - Methods
    func addEntry(amount: Int, containerType: WaterEntry.ContainerType = .cup) {
        let entry = WaterEntry(amount: amount, containerType: containerType)
        todayEntries.append(entry)
        saveEntries()
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
    
    // MARK: - Quick Add Amounts
    var quickAddAmounts: [Int] {
        [250, 500, 750]
    }
    
    // MARK: - Container Presets
    var containerPresets: [(name: String, amount: Int, icon: String)] {
        [
            ("小杯", 250, "cup.and.saucer.fill"),
            ("大杯", 350, "mug.fill"),
            ("水瓶", 500, "bottle.water.fill"),
            ("运动壶", 750, "flask.fill")
        ]
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let waterGoalReached = Notification.Name("waterGoalReached")
}
