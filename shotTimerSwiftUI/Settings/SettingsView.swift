//
//  SettingsView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 31/03/2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @StateObject private var settings = Settings.shared
    @State private var showAlert = false
    @State private var showAutoConfig = false
    @State var isLoggingOut = false

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Button(action: {
                        
                        settingsViewModel.checkBackgroundNoiseLevel()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            showAlert = true
                        }
                            
                    }, label: {
                        Text("Background")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        settingsViewModel.checkShotLevel()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            showAlert = true
                        }
                    }, label: {
                        Text("Shot")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                }
                .padding(10)
                
                Spacer()
                
                Button(action: {
                    showAutoConfig.toggle()
                }, label: {
                    Text("Auto")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .sheet(isPresented: $showAutoConfig) {
                    AutoConfigView()
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 10)
            Form {
                Section(header: Text("Detection Settings")) {
                    HStack {
                        Text("Threshold Level")
                        Spacer()
                        TextField("Threshold Level", value: settings.$detectionLevel, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.default)
                            .frame(width: 80)
                            .submitLabel(.done)
                    }
                    
                    HStack {
                        Text("Random Time Range")
                        Spacer()
                        TextField("Minimum", value: settings.$timeRange, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .submitLabel(.done)
                    }
                    
                    HStack {
                        Text("Sound Name")
                        Spacer()
                        Picker("", selection: $settings.soundName) {
                            Text("Beep 1").tag("beep-01")
                            Text("Beep 2").tag("beep-04")
                            Text("Beep 3").tag("beep-05")
                            Text("Beep 4").tag("beep-06")
                            Text("Beep 5").tag("beep-09")
                        }
                        .pickerStyle(MenuPickerStyle())
                        Button(action: {
                            settingsViewModel.playSelectedSound(soundName: settings.soundName)
                        }, label: {
                            Image(systemName: "play.circle")
                        })
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("logout"){
                guard let user = app.currentUser else { return }
                isLoggingOut = true
                Task {
                    await settingsViewModel.logout(user: user)
                    isLoggingOut = false
                }
            }.disabled(app.currentUser == nil || isLoggingOut))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Measurement Result"), message: Text("\(settingsViewModel.average)"))
            }
                    }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
