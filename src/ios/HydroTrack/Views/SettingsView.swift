//
//  SettingsView.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var waterManager: WaterManager
    @EnvironmentObject var reminderManager: ReminderManager
    @State private var showingGoalSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                // 每日目标
                Section(header: Text("每日目标")) {
                    HStack {
                        Text("每日饮水目标")
                        Spacer()
                        Text("\(waterManager.dailyGoal)ml")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        showingGoalSheet = true
                    }
                    
                    NavigationLink(destination: GoalRecommendationView()) {
                        HStack {
                            Text("智能推荐")
                            Spacer()
                            Text("根据体重计算")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 提醒设置
                Section(header: Text("提醒设置")) {
                    Toggle("启用提醒", isOn: $reminderManager.isEnabled)
                        .onChange(of: reminderManager.isEnabled) { newValue in
                            reminderManager.toggleEnabled(newValue)
                        }
                    
                    Picker("提醒间隔", selection: $reminderManager.reminderInterval) {
                        Text("30 分钟").tag(30)
                        Text("60 分钟").tag(60)
                        Text("90 分钟").tag(90)
                        Text("120 分钟").tag(120)
                    }
                    .onChange(of: reminderManager.reminderInterval) { newValue in
                        reminderManager.updateInterval(newValue)
                    }
                    
                    NavigationLink(destination: QuietHoursView()) {
                        HStack {
                            Text("静音时段")
                            Spacer()
                            Text("22:00 - 07:00")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 外观
                Section(header: Text("外观")) {
                    NavigationLink(destination: ThemeView()) {
                        HStack {
                            Text("主题")
                            Spacer()
                            Text("浅色")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 关于
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "mailto:support@hydrotrack.com")!) {
                        HStack {
                            Text("联系支持")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingGoalSheet) {
                GoalSettingSheet()
            }
        }
    }
}

// MARK: - Goal Setting Sheet
struct GoalSettingSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var waterManager: WaterManager
    @State private var goalAmount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目标设置")) {
                    TextField("每日目标 (ml)", text: $goalAmount)
                        .keyboardType(.numberPad)
                    
                    Text("建议：成人每日 2000-2500ml")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button(action: {
                        if let goal = Int(goalAmount) {
                            waterManager.updateGoal(goal)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("保存")
                                .foregroundColor(Color(hex: "#5AC8FA"))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("设置目标")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Placeholder Views
struct GoalRecommendationView: View {
    var body: some View {
        Text("智能推荐 - 根据体重计算")
            .padding()
    }
}

struct QuietHoursView: View {
    var body: some View {
        Form {
            Section(header: Text("静音时段")) {
                Text("在此期间不会收到提醒")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("静音时段")
    }
}

struct ThemeView: View {
    var body: some View {
        Form {
            Section(header: Text("选择主题")) {
                Text("浅色")
                Text("深色")
                Text("自动")
            }
        }
        .navigationTitle("主题")
    }
}

#Preview {
    SettingsView()
        .environmentObject(WaterManager())
        .environmentObject(ReminderManager())
}
