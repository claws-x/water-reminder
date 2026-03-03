//
//  StatsView.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var waterManager: WaterManager
    @State private var selectedPeriod: Period = .week
    
    enum Period: String, CaseIterable {
        case week = "周"
        case month = "月"
        case year = "年"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 周期选择
                    PeriodPicker(selectedPeriod: $selectedPeriod)
                    
                    // 统计图表
                    StatsChartView(period: selectedPeriod)
                    
                    // 统计摘要
                    StatsSummaryView()
                    
                    // 成就徽章
                    AchievementsView()
                }
                .padding()
            }
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Period Picker
struct PeriodPicker: View {
    @Binding var selectedPeriod: StatsView.Period
    
    var body: some View {
        Picker("周期", selection: $selectedPeriod) {
            ForEach(StatsView.Period.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

// MARK: - Stats Chart View
struct StatsChartView: View {
    let period: StatsView.Period
    
    // 模拟数据
    var sampleData: [(day: String, amount: Int)] {
        switch period {
        case .week:
            return [
                ("一", 1800), ("二", 2200), ("三", 1500),
                ("四", 2500), ("五", 2000), ("六", 1900), ("日", 2100)
            ]
        case .month:
            return [
                ("第 1 周", 2000), ("第 2 周", 2200),
                ("第 3 周", 1800), ("第 4 周", 2400)
            ]
        case .year:
            return [
                ("Q1", 2000), ("Q2", 2100),
                ("Q3", 1900), ("Q4", 2300)
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("饮水趋势")
                .font(.system(size: 18, weight: .semibold))
            
            // 简单柱状图
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(sampleData, id: \.day) { item in
                    VStack(spacing: 4) {
                        Text("\(item.amount / 1000)k")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Rectangle()
                            .fill(Color(hex: "#5AC8FA"))
                            .frame(
                                width: 30,
                                height: CGFloat(item.amount) / 30
                            )
                            .cornerRadius(4)
                        
                        Text(item.day)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 200)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
        }
        .padding()
    }
}

// MARK: - Stats Summary View
struct StatsSummaryView: View {
    @EnvironmentObject var waterManager: WaterManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("统计摘要")
                .font(.system(size: 18, weight: .semibold))
            
            HStack(spacing: 16) {
                StatCard(
                    title: "平均每日",
                    value: "2100ml",
                    icon: "drop.fill",
                    color: "#5AC8FA"
                )
                
                StatCard(
                    title: "连续打卡",
                    value: "7 天",
                    icon: "flame.fill",
                    color: "#FF9500"
                )
                
                StatCard(
                    title: "目标达成",
                    value: "85%",
                    icon: "checkmark.circle.fill",
                    color: "#34C759"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(hex: color).opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Achievements View
struct AchievementsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("成就徽章")
                .font(.system(size: 18, weight: .semibold))
            
            HStack(spacing: 16) {
                AchievementBadge(
                    name: "新手",
                    icon: "star.fill",
                    achieved: true
                )
                
                AchievementBadge(
                    name: "坚持一周",
                    icon: "flame.fill",
                    achieved: true
                )
                
                AchievementBadge(
                    name: "补水达人",
                    icon: "drop.fill",
                    achieved: false
                )
                
                AchievementBadge(
                    name: "月度冠军",
                    icon: "trophy.fill",
                    achieved: false
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct AchievementBadge: View {
    let name: String
    let icon: String
    let achieved: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(achieved ? Color(hex: "#FFD700") : .gray.opacity(0.3))
            
            Text(name)
                .font(.system(size: 12))
                .foregroundColor(achieved ? .primary : .secondary)
        }
        .frame(width: 80)
    }
}

#Preview {
    StatsView()
        .environmentObject(WaterManager())
}
