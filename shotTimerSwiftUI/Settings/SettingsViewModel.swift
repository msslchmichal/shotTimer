//
//  SettingsViewModel.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 01/04/2023.
//

import Foundation
import Combine
import AVFoundation

class SettingsViewModel: ObservableObject {
    
    private let audioManager = AudioManager()
    
    @Published var alertMessage = ""
    @Published var average: Float = 0
    @Published var top5: Float = 0
    @Published var showAlert: Bool = false
    @Published var showAutoConfigView = false
    
    private var backgroundNoise: [Float] = []
    private var shotLevel: [Float] = []
    private var timerCancellable: AnyCancellable?
    private var progress: Double = 0.0
    
    func checkShotLevel() {
        print("func checkShotLevel()")
        audioManager.startRecording()
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.audioManager.audioRecorder.updateMeters()
                let level = self.audioManager.audioRecorder.averagePower(forChannel: 0)
                self.progress += 0.1
                print("Recording level: \(level)")
                self.shotLevel.append(level)
                if self.progress >= 10 {
                    self.timerCancellable?.cancel()
                    self.audioManager.stopRecording()
                    self.shotLevel.sort(by: {$0 > $1})
                    let top5ShotLevel = Array(self.shotLevel.prefix(5))
                    let avgTop5ShotLevel = top5ShotLevel.reduce(0,+) / Float(top5ShotLevel.count)
                    print("Top 5 shot levels: \(top5ShotLevel)")
                    print("Average of top 5 shot levels: \(avgTop5ShotLevel)")
                    self.average = avgTop5ShotLevel
                    self.alertMessage = "Shot level: \(self.average)"
                    self.resetProgress()
                }
            }
    }
    func checkBackgroundNoiseLevel() {
        print("func checkBackGroundNoise()")
        audioManager.startRecording()
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink() {  [weak self] _ in
                guard let self = self else { return }
                self.audioManager.audioRecorder.updateMeters()
                let level = self.audioManager.audioRecorder.averagePower(forChannel: 0)
                // Keep track of time elapsed
                self.progress += 0.1
                print("Recording level: \(level)")
                self.backgroundNoise.append(level)
                // Exit loop after 10 seconds
                if self.progress >= 10 {
                    self.audioManager.stopRecording()
                    self.timerCancellable?.cancel()
                    let sumArray = self.backgroundNoise.reduce(0, +)
                    self.average = sumArray / Float(self.backgroundNoise.count)
                    self.alertMessage = "Background noise level: \(self.average)"
                    print("average: \(self.average)")
                    self.resetProgress()
                }
            }
    }
    func resetProgress() {
        progress = 0
    }
        
    func playSelectedSound(soundName: String) {
        audioManager.playSound(soundName: soundName)
    }
}
