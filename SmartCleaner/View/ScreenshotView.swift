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
                    if !isVideoSelected {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "back"), object: nil, userInfo: nil)
                    }
                    
                    isVideoSelected ? isVideoSelected.toggle() : self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("btn_back")
                })
                Spacer()
                Text("Screenshots")
                    .font(.custom("Poppins-Semibold", size: 24))
                    .frame(width: 0.6 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                    .offset(CGSize(width: -13, height: 0))
                Button(action: {
                    isVideoSelected ? showAlertX.toggle() : isVideoSelected.toggle()
                }, label: {
                    Image("btn_thrash")
                })
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
                .frame(height: 0.05 * screenHeight, alignment: .center)

            GeometryReader { _ in
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: layout) {
                        ForEach(allScreenshot, id: \.self) { screenshot in
                            ZStack{
                                
                            
                            VStack {
                                Image(uiImage: screenshot.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .center)
//                                    .border(Color.purple, width: isVideoSelected ? 5 : 0)
                            }
                                
                              
                                Image("btn_cross_img")
                                    .frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .topTrailing)
                                    .onTapGesture {
                                        print("\(String(describing: screenshot.url)) added")
                                       
                                        screenShotsWillDelete.append(screenshot.url!)
                                        
                                        deleteImage(imageUrls: screenShotsWillDelete)
                                        screenShotsWillDelete = []
                                    }
                            }
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
        
        var assets = [PHAsset]()
        for imageUrl in imageUrls {
            
            
            assets.append(PHAssetForFileURL(url: imageUrl)!)
 
        }
     
        
   
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assets as NSArray)
            }, completionHandler: {
                success, error in
               
                print(success ? "Success" : error as Any)
                
            })
            
        }
      
    }
    
    func PHAssetForFileURL(url: URL) -> PHAsset? {
        var imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.deliveryMode = .fastFormat
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isSynchronous = true
        let fetchResult = PHAsset.fetchAssets(with: nil)
        
        for index in 0...fetchResult.count{
            if let asset = fetchResult[index] as? PHAsset {
            return asset
            }
        }
        return nil
    }
}
