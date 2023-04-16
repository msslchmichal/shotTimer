//
//  ShotDetectorViewModel.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 30/03/2023.
//
import SwiftUI
import Combine
import AVFoundation

class ShotDetectorViewModel: ObservableObject {
    
    enum State {
        case ready, stop, resetOrSave
    }
    
    private let audioManager = AudioManager()
    @Published var state: State = .ready
    @Published var readyButton: String = "Ready"
    @Published var shots: [Shot] = []
    @Published var shotNumber: Int = 0
    @Published var readyButtonIsEnabled: Bool = true
    private var thresholdLevel: Float = Float(Settings.shared.detectionLevel)
    private var randomTimeFrom: Double = Double(Settings.shared.timeRange)
    private var soundName: String = Settings.shared.soundName
    private var startTime: Date?
    private var shotDetected = false
    private var timerCancellable: AnyCancellable?
    
//    MARK: is it overkill?
//    private var settingsCancellable: AnyCancellable?
//    init() {
//        settingsCancellable = Settings.shared.objectWillChange.sink { [weak self] _ in
//            guard let self = self else { return }
//            self.thresholdLevel = Float(Settings.shared.detectionLevel)
//            self.randomTimeFrom = Double(Settings.shared.timeRange)
//            self.soundName = Settings.shared.soundName
//        }
//    }
    
    func startShotRecognition() {
        randomTimeFrom = Double(Settings.shared.timeRange) // Combine or this?
        print("starShotRecognition")
        readyButton = "Be prepared"
        readyButtonIsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: randomTimeFrom...5)) {
            self.state = .stop
            self.startTime = Date()
            self.startRecording()
            self.soundName = Settings.shared.soundName // Combine or this?
            self.playSound(soundName: self.soundName)
        }
    }
    
    func stopShotRecognition() {
        state = .resetOrSave
        stopRecording()
        print("shots: \(shots)")
    }
    
    private func startRecording() {
        thresholdLevel = Float(Settings.shared.detectionLevel) // Combine or this?
        audioManager.startRecording()
        var previousLevel: Float = -160
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.audioManager.audioRecorder.updateMeters()
                let level = self.audioManager.audioRecorder.averagePower(forChannel: 0)
                print("Recording level: \(level)")
                //check for condition
                if level > self.thresholdLevel && level > previousLevel {
                    print("level detected")
                    if !self.shotDetected {
                        print("addShot")
                        self.addShot()
                        self.shotDetected = true
                    }
                } else {
                    self.shotDetected = false
                }
                previousLevel = level // Store the current level for the next comparison
            }
    }
    
    private func addShot() {
        let timeElapsed = Date().timeIntervalSince(startTime!)
        let shot = Shot(number: shotNumber + 1, time: timeElapsed)
        shots.append(shot)
        shotNumber += 1
        shotDetected = false // Reset the shotDetected flag
    }
    
    private func stopRecording() {
        audioManager.stopRecording()
        timerCancellable?.cancel()
    }
    
    private func playSound(soundName: String) {
        audioManager.playSound(soundName: soundName)
    }
    
    func resetShots() {
        state = .ready
        shots.removeAll()
        startTime = nil
        shotNumber = 0
        readyButtonIsEnabled = true
        readyButton = "Ready"
    }
    
    func saveShots() {
        print("Save shots function called.")
    }
}
