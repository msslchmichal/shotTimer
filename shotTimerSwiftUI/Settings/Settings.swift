//
//  Settings.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 12/04/2023.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    static let shared = Settings()
    
    @AppStorage("detectionLevel") var detectionLevel = 0 {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("timerRange") var timeRange = 0 {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("soundName") var soundName = "beep-01" {
        didSet {
            objectWillChange.send()
        }
    }
}
