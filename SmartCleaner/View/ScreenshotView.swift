//
//  ScreenshotView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import AlertX
import ImageViewer
import Photos
import SwiftUI

struct ScreenshotView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var isVideoSelected = false
    @State var choosedVideoNum = 0
    @State var showAlertX: Bool = false
    @State var image = Image("img_example")
    @ObservedObject var screenshots = ScreenshotModel()
    
    @State var lottie = LottieView(lottieFile: "loadingAnimation")
    @State var push = false
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
    ]

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.1 * screenHeight, alignment: .center)
            HStack {
                Button(action: {
                    isVideoSelected ? isVideoSelected.toggle() : self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(isVideoSelected ? "btn_cross" : "btn_back")
                })
                Spacer()
                Text(isVideoSelected ? "\(choosedVideoNum) Selected" : "Screenshots")
                    .font(.custom("Poppins-Semibold", size: 24))
                    .frame(width: 0.6 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                    .offset(CGSize(width: -13, height: 0))
                Button(action: {
                    showAlertX.toggle()
                }, label: {
                    Image("btn_thrash")
                })
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
                .frame(height: 0.05 * screenHeight, alignment: .center)

            GeometryReader { _ in
                lottie
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.2, alignment: .center)
                lottie.opacity(1)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: layout) {
                        ForEach(allScreenshot, id: \.self) { screenshot in
                            VStack {
                                Image(uiImage: screenshot.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .center)
                                    .border(Color.purple, width: 5)
                            }
                            .onTapGesture {
                                print("\(screenshot.url) added")
                                screenShotsWillDelete.append(screenshot.url!)
                            }
                            .onLongPressGesture {}
                        }
                    }
                    Spacer()
                        .frame(height: 0.1 * screenHeight, alignment: .center)
                }.frame(width: screenWidth, height: 0.85 * screenHeight, alignment: .bottom)
            }
            .alertX(isPresented: $showAlertX, content: {
                AlertX(title: Text("Deleting Screenshots"),
                       primaryButton: .cancel(),
                       secondaryButton: .default(Text("Delete")
                           .foregroundColor(Color.red), action: {
                               deleteImage(imageUrls: screenShotsWillDelete)
                           }), theme: .light())
            })
        }
        .navigationBarHidden(true)
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .background(Color.white)
        .onAppear {
            let status = PHPhotoLibrary.authorizationStatus()

            switch status {
            case .authorized:
                print("authorized")

            case .denied:
                print("denied")

            case .notDetermined:
                print("notDetermined")

            case .restricted:
                print("restricted")

            default:
                print("default")
            }
            ScreenshotModel().getAllPhotos()
            
        }
        
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "screenshotPressed")))
                { data in
                    
                    lottie.animationView.stop()
                    lottie.opacity(0)
                    NotificationCenter.default.removeObserver("screenshotPressed")
                }
        
    }
}

struct ScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView()
    }
}

extension ScreenshotView {
    func setScreenShotSelected(imageObj: inout ImageObject) {
        imageObj.isSelected = true
    }

    func deleteImage(imageUrls: [URL]) {
        PHPhotoLibrary.shared().performChanges({
            let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: imageUrls, options: nil)
            PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
        }, completionHandler: {
            success, error in
            print(success ? "Success" : error as Any)

        })
    }
}
