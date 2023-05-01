//
//  ContentView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 24/04/2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var errorHandler: ErrorHandler
    var showDetector = false
    
    var body: some View {
        if let user = app.currentUser {
            ShotDetectorView()
        } else {
            LoginView()
        }
    }
}
