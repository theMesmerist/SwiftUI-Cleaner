//
//  LargeVideosView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI
import AlertX
import Photos
import AVKit

struct LargeVideosView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var isVideoSelected = false
    @State var choosedVideoNum = 0
    @State var showAlertX: Bool = false

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
                        Image(isVideoSelected ? "btn_cross" : "btn_back")
                    })
                Spacer()
                Text(isVideoSelected ? "\(choosedVideoNum) Selected" : "Video Files")
                    .font(.custom("Poppins-Semibold", size: 24))
                    .frame(width: 0.6 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                    .offset(CGSize(width: -12, height: 0))
                Button(action: {
                    self.showAlertX.toggle()
                }, label: {
                        Image(isVideoSelected ? "btn_thrash" : "")
                    })
                    .disabled(!isVideoSelected)
                    .opacity(isVideoSelected ? 1 : 0)
                Spacer()
            }
                .padding(.horizontal)
            Spacer()
                .frame(height: 0.05 * screenHeight, alignment: .center)
            GeometryReader { reader in
                ScrollView(.vertical) {
                    LazyVGrid(columns: layout) {
                        ForEach(Videos.allVideos) { video in
                                    VStack {
                                        ZStack {
                                            CustomPlayer(player: AVPlayer(url: URL(string: video.videoUrl)!))
                                                .frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .center)
                                            VStack {
                                                Spacer()
                                                    .frame(width: 0.27 * screenWidth, height: 0.125 * screenHeight, alignment: .bottom)
                                                Text("\(video.size / 1000000) MB")
                                                    .foregroundColor(.white)
                                                    .frame(width: 0.27 * screenWidth, height: 0.055 * screenHeight, alignment: .center)
                                                    .background(Color.gray)
                                                    .opacity(0.8)
                                            }.frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .center)
                                        }
                                    }.frame(width: 0.27 * screenWidth, height: 0.18 * screenHeight, alignment: .bottom)
                                }
                    }
                    Spacer()
                        .frame(height: 0.1 * screenHeight, alignment: .center)
                }
                    .navigationBarHidden(true)
                    .frame(width: screenWidth, height: 0.85 * screenHeight, alignment: .bottom)
            } .navigationBarHidden(true)
                .alertX(isPresented: $showAlertX, content: {
                AlertX(title: Text("Deleting Videos"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Delete")
                            .foregroundColor(Color.red), action: {
                        })
                    ,
                    theme: .light()
                )
            })
        }
            .navigationBarHidden(true)
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
            .background(Color(bgColor))
    }
}

struct LargeVideosView_Previews: PreviewProvider {
    static var previews: some View {
        LargeVideosView()
    }
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

extension LargeVideosView {
    func fetchAllVideos() {
        Videos.allVideos = []
        let manager = PHImageManager.default()
        let requestOptions = PHVideoRequestOptions()
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        let results: PHFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
//        results.enumerateObjects { asset, index, bool in
        if results.count > 0 {
            print(results.count)
            for i in 0..<results.count {
                let asset = results.object(at: i)
                manager.requestAVAsset(forVideo: asset, options: requestOptions) { asset, audio, info in
                    if asset != nil {
                        let avAsset = asset as! AVURLAsset
                        let urlVideo = avAsset.url
                        let assetSize = AVURLAsset(url: urlVideo)
                        let video = Videos()
                        video.videoUrl = urlVideo.absoluteString
                        video.size = assetSize.fileSize!
                        Videos.allVideos.append(video)
                        print(urlVideo)
                        Videos.allVideos = Videos.allVideos.sorted(by: { $0.size > $1.size })
                    }
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videosFetchFinished"), object: nil, userInfo: nil) 
    }
}
