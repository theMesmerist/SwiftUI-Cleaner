//
//  SettingsView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI
import AppTrackingTransparency

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var notify = false
    @State private var touchID = false
    var body: some View {
        VStack {
            Spacer()
                .frame(width: screenWidth * 0.38, height: 0.07 * screenHeight, alignment: .center)
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                        Image("btn_cross")
                    })
                Spacer()
                Text("Settings")
                    .font(.custom("Poppins-Semibold", size: 24))
                Spacer()
                    .frame(width: screenWidth * 0.33, height: 0.05 * screenHeight, alignment: .center)
            }
                .padding(.horizontal)
            VStack {
                
                SettingsButton(btnText: "Photo Access")
                SettingsButton(btnText: "Share with your friends")
                SettingsButton(btnText: "Help & Support")
                SettingsButton(btnText: "Terms of Use")
                SettingsButton(btnText: "Privacy Policy")
            }
            Spacer()
        }
            .navigationBarHidden(true)
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
            .background(LinearGradient(colors: [Color.white, Color(bgColor)], startPoint: .top, endPoint: .bottom))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


extension View {
    func toggleBackground() -> some View {
        self
            .foregroundColor(.black)
            .tint(Color(UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)))
            .padding(.horizontal)
            .frame(width: 0.9 * screenWidth, height: 0.065 * screenHeight, alignment: .center)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 1)
            .padding(.bottom, 10)
    }
}
