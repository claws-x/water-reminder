//
//  ContentView.swift
//  HydroTrack
//
//  喝水提醒主界面
//

import SwiftUI

struct ContentView: View {
    @State private var dailyGoal: Int = 8
    @State private var cupsConsumed: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 进度环
                ProgressView(value: Double(cupsConsumed), total: Double(dailyGoal))
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0)
                    .padding()
                
                Text("今日已喝 \(cupsConsumed) / \(dailyGoal) 杯")
                    .font(.title2)
                
                // 喝水按钮
                Button(action: {
                    if cupsConsumed < dailyGoal {
                        cupsConsumed += 1
                    }
                }) {
                    Text("💧 喝一杯")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // 目标设置
                Stepper(value: $dailyGoal, in: 4...12) {
                    Text("每日目标：\(dailyGoal) 杯")
                }
                
                Spacer()
            }
            .navigationTitle("HydroTrack")
        }
    }
}

#Preview {
    ContentView()
}
