//
//  AutoConfigViewModel.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 03/04/2023.
//

import Foundation
import Combine
import AVFoundation

class AutoConfigViewModel: ObservableObject {
    
    enum State {
        case listen, shot, listenCompleted, shotCompleted, progres, result
    }
    
    private let audioManager = AudioManager()
    
    @Published var state: State = .listen
    @Published var showAutoConfigView = false
    @Published var progress: Double = 0.0
    @Published var total: Double = 0.0
    @Published var result: String = ""
    
    private var timerCancellable: AnyCancellable?
    private var shotLevel: [Float] = []
    private var backgroundNoise: [Float] = []
    private var average: Float = 0
    private var top5: Float = 0
    
    func listenStart() {
        resetProgress()
        state = .progres
        print("func start()")
        total = 10
        audioManager.startRecording()
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink() {  [weak self] _ in
                guard let self = self else { return }
                self.audioManager.audioRecorder.updateMeters()
                let level = self.audioManager.audioRecorder.averagePower(forChannel: 0)
                self.progress += 0.1
                print("Recording level: \(level)")
                self.backgroundNoise.append(level)
                // Exit loop after 10 seconds
                if self.progress >= 10 {
                    self.stopRecording()
                    let sumArray = self.backgroundNoise.reduce(0, +)
                    self.average = sumArray / Float(self.backgroundNoise.count)
                    print("average: \(self.average)")
                    self.state = .listenCompleted
                }
            }
    }
            
    func shotStart() {
        resetProgress()
        print("recordShots()")
        audioManager.startRecording()
        total = 10
        state = .progres
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.audioManager.audioRecorder.updateMeters()
                let level = self.audioManager.audioRecorder.averagePower(forChannel: 0)
                self.progress += 0.1
                print("Recording level: \(level)")
                self.shotLevel.append(level)
                // Exit loop after 10 seconds
                if self.progress >= 10 {
                    self.stopRecording()
                    self.shotLevel.sort(by: {$0 > $1})
                    let top5ShotLevel = Array(self.shotLevel.prefix(5))
                    let avgTop5ShotLevel = top5ShotLevel.reduce(0,+) / Float(top5ShotLevel.count)
                    print("Top 5 shot levels: \(top5ShotLevel)")
                    print("Average of top 5 shot levels: \(avgTop5ShotLevel)")
                    self.calculateSettings(avg: self.average, top5: avgTop5ShotLevel)
                    self.state = .shotCompleted
                }
            }
    }
    
    func resetProgress() {
        progress = 0
    }
    
    private func stopRecording() {
        audioManager.stopRecording()
        timerCancellable?.cancel()
        
    }
    
    func dismiss() {
        stopRecording()
        showAutoConfigView = false
    }
    
    func hideCompleteFirstStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.state = .shot
        }
    }
    func hideCompleteSecondStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.state = .result
        }
    }
    
    private func calculateSettings(avg: Float, top5: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideCompleteSecondStep()
        }
        print(avg)
        print(top5)
        if (avg+20<top5) {
            Settings.shared.detectionLevel = Int(top5-5)
            result = "Diff is above 20  \nTop5avg: \(top5), \nbg avg: \(avg)\n top5-5 set to UserDefaults"
        }
        else {
            print("Diff is <20, might not work properly")
            result = "Diff is <20, might not work properly \nTop5avg: \(top5), \nbg avg: \(avg)\n set up level manually"
        }
    }
}
