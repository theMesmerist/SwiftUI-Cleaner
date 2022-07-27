//
//  HomeButtuns.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI

struct HomeButton: View {
    
    @State var btnImg: String = ""
    @State var btnTitle: String = "Vault"
    @State var btnDescription: String = "Keep your private media safe in encrypted area"
    @State var isLarge: Bool = false
    @State var isDuplicate: Bool = false
    @State var isScreenShot: Bool = false
    @State var isVault: Bool = false
    @State var isPass: Bool = false
    @State var isPassExists = false
    @State var passwordExist = UserDefaults.standard.bool(forKey: "passwordExist")
    @State var destinationView = VaultWelcomeView()


    var body: some View {

        NavigationLink(destination: LargeVideosView(), isActive: $isLarge) {
            EmptyView()
        }
        NavigationLink(destination: LoaderView(), isActive: $isScreenShot) {
            EmptyView()
        }

        NavigationLink(destination: VaultWelcomeView(), isActive: $isVault) {
            EmptyView()
        }

        NavigationLink(destination: PasswordView(), isActive: $isPass) {
            EmptyView()
        }

        NavigationLink(destination: DuplicatesView(), isActive: $isDuplicate) {
            EmptyView()
        }


        VStack {
            Button {
                switch btnTitle {
                case "Large Videos":
                    sender = "getLargeVideos"
                    isScreenShot.toggle()
                case "Duplicates":
                    sender = "getDuplicates"
                    isDuplicate.toggle()
                case "Screenshot":
                    sender = "getScreenShots"
                    isScreenShot.toggle()
                case "Vault":
                    if passwordExist {
                        isPass.toggle()
                    } else {
                        isVault.toggle()
                    }
                default:

                    print("zırla")
                }
            } label: {
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 0.15 * screenWidth, height: 0.15 * screenWidth, alignment: .top)
                            .foregroundColor(Color(purpleColor))
                        Image(btnImg)
                            .resizable()
                            .frame(width: 0.075 * screenWidth, height: 0.075 * screenWidth, alignment: .center)

                    }
                    Text(btnTitle)
                        .frame(width: 0.4 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                        .foregroundColor(Color(titleColor))
                        .font(.custom("Poppins-Regular", size: 20))
                    Text(btnDescription)
                        .frame(width: 0.35 * screenWidth, height: 0.06 * screenHeight, alignment: .top)
                        .foregroundColor(Color(descriptionColor))
                        .font(.custom("Poppins-Regular", size: 12))
                }
            }
                .frame(width: 0.425 * screenWidth, height: 0.23 * screenHeight, alignment: .center)
                .background(.white)
                .clipped()
                .shadow(color: Color(shadowColor), radius: 6, x: 0, y: 0)

        }
    }
}

struct HomeButtuns_Previews: PreviewProvider {
    static var previews: some View {
        HomeButton()
    }
}
