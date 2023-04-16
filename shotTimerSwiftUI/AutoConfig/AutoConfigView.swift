//
//  AutoConfigView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 02/04/2023.
//

import SwiftUI

struct AutoConfigView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AutoConfigViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .listen:
                    VStack {
                        Text("Press start and record background noise level for 10s")
                            .padding()
                        Button(action: {
                            viewModel.listenStart()
                        }) {
                            Text("Start")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 50)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }

                case .listenCompleted:
                    Text("Completed")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.title)
                        .onAppear {
                                viewModel.hideCompleteFirstStep()
                        }

                case .shot:
                    VStack {
                        Text("Press start and shoot at least 5 times in 10 seconds")
                            .padding()
                        Button(action: {
                            viewModel.shotStart()
                        }) {
                            Text("Start")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 50)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                                .font(.title)
                        }
                    }
                
                case .shotCompleted:
                    Text("Completed")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.title)
                        .onAppear {
                                viewModel.hideCompleteSecondStep()
                        }
                
                case .progres:
                    ZStack {
                        Text(String(format: "%.0f", viewModel.progress))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        
                        ProgressCircleView(viewModel: viewModel)
                    }
                case .result:
                    Text(viewModel.result)
                        .padding()
                }
            }
            .animation(.easeInOut, value: viewModel.state)
            .navigationBarTitle("Auto Settings")
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Text("Done")
            })
        }
    }
}
struct AutoConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AutoConfigView()
    }
}

