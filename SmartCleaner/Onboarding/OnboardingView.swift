//
//  OnboardingView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 1.06.2022.
//

import SwiftUI

struct OnboardData {

    let onbImg: String
    let onbSlideImg: String
    let onbHeader: String
    let onbText: String
}

struct OnboardingView: View {


    @State private var onbCount = 1
    @State private var isActive = false
    @State private var index = 0
    @State var willMoveToNextScreen = false

    let data = [
        OnboardData(onbImg: "img_onboarding1", onbSlideImg: "img_slider01", onbHeader: "Purify Your Gallery", onbText: "The app detects duplicate photos and screenshots in your gallery and shows them to you."),
        OnboardData(onbImg: "img_onboarding2", onbSlideImg: "img_slider02", onbHeader: "Say Goodbye To Huge Videos", onbText: "The app detects huge videos that take up too much space on your device's memory card."),
        OnboardData(onbImg: "img_onboarding3", onbSlideImg: "img_slider03", onbHeader: "Hide Your Private Media", onbText: "Import your private photos into the app and save them in your private album within the app by specifying a password."),
    ]

    var body: some View {
        VStack {
            Image(data[index].onbImg)
                .padding(.vertical, 15)
            Image(data[index].onbSlideImg)
                .padding(.top, 25)
                .padding(.bottom, 10)
            Text(data[index].onbHeader)
                .font(.custom("Poppins-Medium", size: 22))
                .foregroundColor(Color(titleColor))
                .multilineTextAlignment(.center)
                .padding(.top, 15)
            Text(data[index].onbText)
                .font(.custom("Poppins-Light", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(descriptionColor))
                .frame(height: 0.27 * screenWidth, alignment: .top)
                .padding(.horizontal, 0.1 * screenWidth)
                .padding(.bottom, 20)
            Button {
                if index != 2 {
                    index = index + 1
                } else {
                    uDefaults.setValue(true, forKey: "isUserFirst")
                    willMoveToNextScreen.toggle()
                }
            } label: {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Medium", size: 16))
                    .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                    .contentShape(Rectangle())
            }.background(Color(purpleColor))
        }.background(LinearGradient(colors: [Color.white, Color(bgColor)], startPoint: .top, endPoint: .bottom))
            .fullScreenCover(isPresented: $willMoveToNextScreen, content: inApp.init)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
