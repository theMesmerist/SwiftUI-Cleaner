//
//  VaultView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI
import UIKit
import Foundation

struct VaultWelcomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var isFirst = false
    @State var isLater = false
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("btn_back")
                })
            }.frame(width: screenWidth * 0.9, height: screenHeight * 0.1, alignment: .leading)

            Spacer().frame(width: screenWidth, height: 0.1 * screenHeight, alignment: .center)

            Text("Welcome to Secret\nVault")
                .frame(width: screenWidth * 0.6, height: 0.1 * screenHeight, alignment: .center)
                .font(.custom("Poppins-Regular", size: 24))
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text("Hide your private photos and videos by creating a strong PIN code.")
                .frame(width: screenWidth * 0.8, height: 0.1 * screenHeight, alignment: .center)
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)

            Button(action: {
                isFirst.toggle()
            }, label: {
                Text("Create a code")
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.05, alignment: .center)
                    .foregroundColor(Color.white)
            })
                .frame(width: screenWidth * 0.6, height: screenHeight * 0.05, alignment: .center)
                .background(Color(UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)))
                .contentShape(Rectangle())
                .padding(.bottom)
            Button(action: {
                isLater.toggle()
            }, label: {
                Text("Later")
                    .foregroundColor(Color.black)
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.05, alignment: .center)
            })
                .frame(width: screenWidth * 0.6, height: screenHeight * 0.05, alignment: .center)
                .background(Color.white)
                .shadow(radius: 1)


            Spacer().frame(width: screenWidth, height: 0.3 * screenHeight, alignment: .center)
        }
            .frame(width: screenWidth, height: screenHeight)
            .edgesIgnoringSafeArea(.all)
            .background(LinearGradient(colors: [Color.white, Color(bgColor)], startPoint: .top, endPoint: .bottom))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isLater, content: {
            StorageListView()
        })
            .fullScreenCover(isPresented: $isFirst, content: {
            PasscodeView()
        })


    }
}

struct VaultWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        VaultWelcomeView()
    }
}
