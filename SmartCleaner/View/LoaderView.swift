//
//  LoaderView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 22.07.2022.
//

import SwiftUI

struct LoaderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let notification1 = NotificationCenter.default.publisher(for: NSNotification.Name("screenshotFetchFinished"))
    let notification2 = NotificationCenter.default.publisher(for: NSNotification.Name("videosFetchFinished"))
    let notification3 = NotificationCenter.default.publisher(for: NSNotification.Name("back"))
    let notification4 = NotificationCenter.default.publisher(for: NSNotification.Name("duplicatesFetchFinished"))
    
    
    @State var isScreenshot = false
    @State var isVideo = false
    @State var isDuplicate = false
    @State var lottie = LottieView(lottieFile: "animationMain")
    
    var body: some View {
        lottie
            .navigationBarHidden(true)
            .onAppear{
                switch sender{
                case "getScreenShots":
                    ScreenshotModel().getAllPhotos()
                case "getLargeVideos":
                    LargeVideosView().fetchAllVideos()
                case "getDuplicates":
                    photoLibraryAuthorization(success: { takeAssets() }, failed: { fatalError("You need to be authorized") })
                default:
                    print("default")
                }
                
                
            }
            .onReceive(notification1, perform: { _ in
                isScreenshot.toggle()
            })
           
            .onReceive(notification2, perform: {_ in
                isVideo.toggle()
            })
        
            .onReceive(notification3, perform: {_ in
                self.presentationMode.wrappedValue.dismiss()
            })
            .onReceive(notification4, perform: {_ in
                isDuplicate.toggle()
            })
           
            .fullScreenCover(isPresented: $isVideo, content: LargeVideosView.init)
            .fullScreenCover(isPresented: $isScreenshot, content: ScreenshotView.init)
            .fullScreenCover(isPresented: $isDuplicate, content: DuplicatesView.init)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
