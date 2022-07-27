//
//  CircleProgressBar.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 10.06.2022.
//

import SwiftUI

struct CircleProgressBar: View {
    @Binding var progress: Float
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15.0)
                .opacity(0.3)
                .foregroundColor(Color(UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(purpleColor))
                .rotationEffect(Angle(degrees: 270.0))
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }.frame(width: 0.35 * screenWidth, height: 0.35 * screenHeight, alignment: .center)
    }
}

struct CircleProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
