//
//  MainView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI
import SystemServices
import PhotosUI

struct MainView: View {
    @State var isPremiumClicked = false
    @State var progress = Float()
    @State var isSettingsClicked = false
    @State var isUIView = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: inApp(), isActive: $isPremiumClicked) {
                    EmptyView()
                }

                NavigationLink(destination: SettingsView(), isActive: $isSettingsClicked) {
                    EmptyView()
                }

                HStack {
                    Button {
                        isPremiumClicked.toggle()
                    } label: {
                        HStack {
                            Image("img_premium")
                            Text("Try Premium")
                                .foregroundColor(Color(titleColor))
                                .padding(.trailing, 10)

                        }

                            .font(.custom("Poppins-Regular", size: 20))
                    }.background(.white)
                        .clipped().shadow(color: Color(shadowColor), radius: 6, x: 0, y: 0)

                    Spacer()
                    Button {
                        isSettingsClicked.toggle()
                    } label: {
                        Image("btn_settings")
                    }
                }
                    .padding(.horizontal)
                    .onAppear {
                    let password = UserDefaults.standard.object(forKey: "Password")
                }
                VStack {
                    Text("Your Storage")
                        .foregroundColor(Color(titleColor))
                        .font(.custom("Poppins-Medium", size: 24))
                        .padding(.top, 10)
                    CircleProgressBar(progress: $progress).frame(width: 0.35 * screenWidth, height: 0.35 * screenWidth, alignment: .center)
                        .padding(.bottom, 25)
                }.frame(width: 0.9 * screenWidth, height: 0.25 * screenHeight, alignment: .center)
                    .background(.white)
                    .clipped()
                    .shadow(color: Color(shadowColor), radius: 6, x: 0, y: 0)
                HStack {
                    Text("Features")
                        .foregroundColor(Color(titleColor))
                        .padding(.leading)
                    Spacer()
                }
                VStack(spacing: 18) {
                    HStack {
                        HomeButton(btnImg: "img_video", btnTitle: "Large Videos", btnDescription: "Detecting huge videos that take up a lot of space", isLarge: false)
                        Spacer()
                        HomeButton(btnImg: "img_duplicate", btnTitle: "Duplicates", btnDescription: "View duplicate photos in your gallery", isDuplicate: false)
                            .onTapGesture {
                            isUIView.toggle()
                        }
                    }
                    HStack {
                        HomeButton(btnImg: "img_screenshot", btnTitle: "Screenshot", btnDescription: "See repeated screenshots in your gallery", isScreenShot: false)
                        Spacer()
                        HomeButton(btnImg: "img_vault", btnTitle: "Vault", btnDescription: "Keep your private media safe in encrypted area", isVault: false)
                    }
                }.frame(width: 0.9 * screenWidth, alignment: .center)
            }.onAppear {
                calculateProgress(progress: progress)
                requestPermission()
                duplicates?.append([PHAsset]())
               
                LargeVideosView().fetchAllVideos()
                photoLibraryAuthorization(success: { takeAssets() }, failed: { fatalError("You need to be authorized") })
            }
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .edgesIgnoringSafeArea(.all)
                .background(LinearGradient(colors: [Color.white, Color(bgColor)], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

private extension MainView {
    func calculateProgress(progress: Float) {
        let systemServices = SystemServices()
        let usedSpace = ((CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1)) - CGFloat(freeDiskSpaceInBytesImportant / 1000000000)) / ((CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1)))
        print(usedSpace)
        self.progress = Float(usedSpace)
    }


}
