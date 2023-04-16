//
//  ControlMenuView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 01/04/2023.
//

import SwiftUI

struct ControlMenuView: View {
    @ObservedObject var viewModel: ShotDetectorViewModel
    var body: some View {
        Spacer()
        switch viewModel.state {
        case .ready:
            VStack {
                Text("Start shot recognition")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding()
                Button(action: {
                    viewModel.startShotRecognition()
                }, label: {
                    Text(viewModel.readyButton)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .background(Color.green)
                        .cornerRadius(10)
                })
                .disabled(!viewModel.readyButtonIsEnabled)
                .padding()
            }
            
        case .stop:
            Button(action: {
                viewModel.stopShotRecognition()
            }, label: {
                Text("Stop")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                    .background(Color.red)
                    .cornerRadius(10)
            })
            .padding()
            
        case .resetOrSave:
            HStack {
                Button(action: {
                    viewModel.resetShots()
                }, label: {
                    Text("Reset")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                Spacer()
                Button(action: {
                    viewModel.saveShots()
                }, label: {
                    Text("Save")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.green)
                        .cornerRadius(10)
                })
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .padding()
        }
    }
}

//struct ControlMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlMenuView(viewModel: <#ShotDetectorViewModel#>)
//    }
//}
