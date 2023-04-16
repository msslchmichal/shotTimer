//
//  ShotDetectorView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 30/03/2023.
//

import SwiftUI

struct ShotDetectorView: View {
    @ObservedObject var viewModel = ShotDetectorViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.shots) { shot in
                        HStack {
                            Text("\(shot.number).")
                            Spacer()
                            Text("\(shot.formattedTime)s")
                        }
                    }
                }
                .listStyle(InsetListStyle())
                
                Spacer()
                
                ControlMenuView(viewModel: viewModel)
            }
            .navigationBarTitle("Shot Timer")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: SettingsView().environmentObject(viewModel)) {
                Image(systemName: "gear")
                    .font(.title2)
                    .padding(.bottom)
                    .padding(.top)
                    .foregroundColor(.blue)
            })
        }
    }
}

struct ShotCompareView_Previews: PreviewProvider {
    static var previews: some View {
        ShotDetectorView()
    }
}
