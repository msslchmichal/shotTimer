//
//  shotTimerSwiftUIApp.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 30/03/2023.
//

import SwiftUI

import RealmSwift
let theAppConfig = loadAppConfig()
let app = App(id: theAppConfig.appId, configuration: AppConfiguration(baseURL: theAppConfig.baseUrl, transport: nil, localAppName: nil, localAppVersion: nil))

@main
struct shotTimerSwiftUIApp: SwiftUI.App {
    
    @StateObject var errorHandler = ErrorHandler(app: app)
    
    var body: some Scene {
        WindowGroup {
            ContentView(app: app)
                .environmentObject(errorHandler)
                .alert(Text("Error"), isPresented: .constant(errorHandler.error != nil)) {
                    Button("OK", role: .cancel) { errorHandler.error = nil }
                } message: {
                    Text(errorHandler.error?.localizedDescription ?? "")
                }
        }
    }
}

final class ErrorHandler: ObservableObject {
    @Published var error: Swift.Error?
    init(app: RealmSwift.App) {
        app.syncManager.errorHandler = { syncError, syncSession in
            self.error = syncError
        }
    }
}
