//
//  HomeView.swift
//  HydroTrack
//
//  Created by AIagent on 2026-03-03.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var waterManager: WaterManager
    @EnvironmentObject var reminderManager: ReminderManager
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 进度圆环
                    ProgressRingView(
                        progress: waterManager.progressPercent,
                        total: waterManager.todayTotal,
                        goal: waterManager.dailyGoal
                    )
                    
                    // 快速添加按钮
                    QuickAddButtonsView(showingAddSheet: $showingAddSheet)
                    
                    // 今日记录列表
                    TodayEntriesView()
                }
                .padding()
            }
            .navigationTitle("今日进度")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "#5AC8FA"))
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEntrySheet()
            }
        }
    }
}

// MARK: - Progress Ring View
struct ProgressRingView: View {
    let progress: Double
    let total: Int
    let goal: Int
    
    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                .frame(width: 250, height: 250)
            
            // 进度圆环
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(hex: "#5AC8FA"),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // 中心文字
            VStack(spacing: 8) {
                Text("\(total)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color(hex: "#5AC8FA"))
                
                Text("ml / \(goal)ml")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                Text("已完成 \(Int(progress * 100))%")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - Quick Add Buttons
struct QuickAddButtonsView: View {
    @EnvironmentObject var waterManager: WaterManager
    @Binding var showingAddSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快速添加")
                .font(.system(size: 18, weight: .semibold))
            
            HStack(spacing: 16) {
                ForEach(waterManager.containerPresets, id: \.name) { container in
                    QuickAddButton(
                        name: container.name,
                        amount: container.amount,
                        icon: container.icon
                    ) {
                        waterManager.addEntry(amount: container.amount)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct QuickAddButton: View {
    let name: String
    let amount: Int
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#5AC8FA"))
                
                Text(name)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("\(amount)ml")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(hex: "#5AC8FA").opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Today Entries View
struct TodayEntriesView: View {
    @EnvironmentObject var waterManager: WaterManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("今日记录")
                .font(.system(size: 18, weight: .semibold))
            
            if waterManager.todayEntries.isEmpty {
                Text("还没有记录，快添加第一杯水吧！")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(waterManager.todayEntries) { entry in
                    EntryRowView(entry: entry)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct EntryRowView: View {
    let entry: WaterEntry
    
    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundColor(Color(hex: "#5AC8FA"))
            
            VStack(alignment: .leading) {
                Text("\(entry.amount)ml")
                    .font(.system(size: 16, weight: .medium))
                
                Text(entry.date, style: .time)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Add Entry Sheet
struct AddEntrySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var waterManager: WaterManager
    @State private var customAmount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("选择容量")) {
                    ForEach(waterManager.containerPresets, id: \.name) { container in
                        Button(action: {
                            waterManager.addEntry(amount: container.amount)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: container.icon)
                                Text("\(container.name) - \(container.amount)ml")
                            }
                        }
                    }
                }
                
                Section(header: Text("自定义")) {
                    HStack {
                        TextField("输入容量 (ml)", text: $customAmount)
                            .keyboardType(.numberPad)
                        
                        Button(action: {
                            if let amount = Int(customAmount) {
                                waterManager.addEntry(amount: amount)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("添加")
                                .foregroundColor(Color(hex: "#5AC8FA"))
                        }
                    }
                }
            }
            .navigationTitle("添加记录")
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

#Preview {
    HomeView()
        .environmentObject(WaterManager())
        .environmentObject(ReminderManager())
}
