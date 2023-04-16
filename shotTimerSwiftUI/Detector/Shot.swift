//
//  Shot.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 31/03/2023.
//

import Foundation

struct Shot: Identifiable {
    let id = UUID()
    let number: Int
    let time: TimeInterval
    var formattedTime: String {
        String(format: "%.2f", time)
    }
}
