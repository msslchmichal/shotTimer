//
//  ProgressCircleView.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 04/04/2023.
//

import SwiftUI

struct ProgressCircleView: View {
    @ObservedObject var viewModel: AutoConfigViewModel
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.red)
                .opacity(0.3)
            Circle()
                .trim(from: 0.0, to: CGFloat(viewModel.progress)/CGFloat(viewModel.total))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: viewModel.progress)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}

//struct ProgressCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressCircleView()
//    }
//}
