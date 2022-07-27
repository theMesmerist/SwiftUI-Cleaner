//
//  DuplicateView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 15.06.2022.
//

import AlertX
import Photos
import SwiftUI
import UIKit

struct DuplicatesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isVideoSelected = false
    @State var choosedVideoNum = 0
    @State var showAlertX: Bool = false

    var photoAsset: PHFetchResult<PHAsset>?
    var videoAsset: PHFetchResult<PHAsset>?
    var screenshotAsset: PHFetchResult<PHAsset>?

    var reloadCount = 0
    let lblDuplicate = UILabel()
    let deletePopView = UIView()
    var assetsToDelete = [PHAsset]()
    var duplicates: [[PHAsset]]?

    let layout = [
        GridItem(.fixed(110))
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
                Text(isVideoSelected ? "\(choosedVideoNum) Selected" : "Duplicated")
                    .font(.custom("Poppins-Semibold", size: 24))
                    .frame(width: 0.8 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                Button(action: {
                    self.showAlertX.toggle()

                }, label: {
                    Image(isVideoSelected ? "btn_thrash" : "")
                })
                .disabled(!isVideoSelected)
                .opacity(isVideoSelected ? 1 : 0)
                Spacer()
            }
            .frame(width: screenWidth * 0.8)
            .padding(.horizontal)
            GeometryReader { _ in
                ScrollView(.vertical) {
                    LazyVGrid(columns: layout) {
                        ForEach(arrDuplicateImageGroups.filter({$0.count > 0 }), id: \.self) { item in
                            VStack {
                                Image(uiImage:  item[0])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.3, alignment: .center)
                                    
                                HStack {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(item, id: \.self) { i in
                                                HStack {
                                                    ZStack {
                                                        Image(uiImage: i)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .blur(radius: 7)
                                                            .frame(width: screenWidth * 0.35, height: screenHeight * 0.2, alignment: .center)
                                                        Image(uiImage: i)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: screenWidth * 0.4, height: screenHeight * 0.2, alignment: .center)
                                                        Button(action: {}, label: {
                                                            Image("btn_cross_img")
                                                                .frame(width: screenWidth * 0.35, height: screenHeight * 0.19, alignment: .topTrailing)
                                                        })
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.3, alignment: .top)
//                                        Spacer()
//                                            .frame(height: 0.05 * screenHeight, alignment: .center)
                                }
                            }
                        }
                    }
                }
                .frame(width: screenWidth, height: 0.8 * screenHeight, alignment: .bottom)
            }
            .alertX(isPresented: $showAlertX, content: {
                AlertX(title: Text("Deleting Screenshots"),
                       primaryButton: .cancel(),

                       secondaryButton: .default(Text("Delete")
                           .foregroundColor(Color.red), action: {}),

                       theme: .light())
            })
        }
        .frame(width: screenWidth, height: screenHeight, alignment: .top)
        .navigationBarHidden(true)
        .background(Color(bgColor))
        
    }
}

struct DuplicatesView_Previews: PreviewProvider {
    static var previews: some View {
        DuplicatesView()
    }
}
