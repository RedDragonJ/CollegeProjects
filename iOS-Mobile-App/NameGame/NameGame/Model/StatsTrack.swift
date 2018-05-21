//
//  StatsTrack.swift
//  NameGame
//
//  Created by James H Layton on 4/26/18.
//  Copyright © 2018 james. All rights reserved.
//

import Foundation

enum GameMode {
    case normal
    case matt
    case reverse
    case hint
    case team
}

class StatsTrack {
    static let shared = StatsTrack()
    private init (){}
    
    // Track general stats
    var incorrectAttempts: Int = 0
    var problemStartTime: Date?
    var problemEndTime: Date? {
        didSet {
            findTimeDifference()
        }
    }
    var solveProblemTime: TimeInterval?
    
    // Track Hint Mode Timer
    var hintModeTimer: Timer?
    var hintTime: Double = 60.0
    
    // Track Game Mode
    var gameMode: GameMode = GameMode.matt
    
    private func findTimeDifference() {
        if self.problemEndTime != nil {
            let interval = self.problemEndTime!.timeIntervalSince(self.problemStartTime!)
            self.solveProblemTime = interval
        }
    }
    
    func stopHintTimer() {
        self.hintTime = 60.0
        self.hintModeTimer?.invalidate()
        self.hintModeTimer = nil
    }
    
    func resetStats() {
        self.incorrectAttempts = 0
        self.problemStartTime = nil
        self.problemEndTime = nil
        self.solveProblemTime = nil
        self.stopHintTimer()
    }
}
