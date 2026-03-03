//
//  HydroTrackTests.swift
//  HydroTrackTests
//
//  Created by AIagent on 2026-03-03.
//

import XCTest
@testable import HydroTrack

final class HydroTrackTests: XCTestCase {
    
    var waterManager: WaterManager!
    var reminderManager: ReminderManager!
    
    override func setUpWithError() throws {
        waterManager = WaterManager()
        reminderManager = ReminderManager()
    }
    
    override func tearDownWithError() throws {
        waterManager = nil
        reminderManager = nil
    }
    
    // MARK: - Water Entry Tests
    
    func testAddWaterEntry() throws {
        let initialCount = waterManager.todayEntries.count
        waterManager.addEntry(amount: 250)
        XCTAssertEqual(waterManager.todayEntries.count, initialCount + 1)
    }
    
    func testTodayTotal() throws {
        waterManager.addEntry(amount: 250)
        waterManager.addEntry(amount: 500)
        XCTAssertEqual(waterManager.todayTotal, 750)
    }
    
    func testProgressPercent() throws {
        waterManager.dailyGoal = 2000
        waterManager.addEntry(amount: 1000)
        XCTAssertEqual(waterManager.progressPercent, 0.5, accuracy: 0.01)
    }
    
    func testRemainingAmount() throws {
        waterManager.dailyGoal = 2000
        waterManager.addEntry(amount: 500)
        XCTAssertEqual(waterManager.remainingAmount, 1500)
    }
    
    func testUpdateGoal() throws {
        waterManager.updateGoal(2500)
        XCTAssertEqual(waterManager.dailyGoal, 2500)
    }
    
    // MARK: - Reminder Tests
    
    func testToggleReminder() throws {
        reminderManager.toggleEnabled(true)
        XCTAssertTrue(reminderManager.isEnabled)
        
        reminderManager.toggleEnabled(false)
        XCTAssertFalse(reminderManager.isEnabled)
    }
    
    func testUpdateInterval() throws {
        reminderManager.updateInterval(90)
        XCTAssertEqual(reminderManager.reminderInterval, 90)
    }
    
    // MARK: - Container Presets
    
    func testContainerPresets() throws {
        let presets = waterManager.containerPresets
        XCTAssertGreaterThan(presets.count, 0)
        
        for preset in presets {
            XCTAssertGreaterThan(preset.amount, 0)
            XCTAssertFalse(preset.icon.isEmpty)
        }
    }
    
    // MARK: - Performance Tests
    
    func testAddEntryPerformance() throws {
        self.measure {
            for _ in 0..<50 {
                waterManager.addEntry(amount: 250)
            }
        }
    }
}
