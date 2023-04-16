//
//  AudioManager.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 15/04/2023.
//

import Foundation
import AVFoundation

class AudioManager {
    
    let audioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    private var player: AVAudioPlayer?
    
    func startRecording() {
        
        print("AudioManager.startRecording()")
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.wav")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()

        } catch {
            print("Error starting audio recording: \(error.localizedDescription)")
        }
        
    }
    
    func stopRecording() {
        print("AudioManager.stopRecording()")
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error stopping audio session: \(error.localizedDescription)")
        }
        
    }
    
    func playSound(soundName: String) {
        print("AudioManager.playSound()")
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

