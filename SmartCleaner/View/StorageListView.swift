//
//  StorageListView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 9.06.2022.
//

import SwiftUI
import AudioToolbox
import CoreData
import ImageViewer

struct StorageListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Photo.entity(), sortDescriptors: []) var photos: FetchedResults<Photo>
    @State var isMain = false
    @State var showImagePicker = false
    @State var showImageViewer: Bool = false
    @State var image = Image("img_example")
    
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
    ]

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.07 * screenHeight, alignment: .center)
            HStack {
                Button(action: {
                    isMain.toggle()
                }, label: {
                        Image("btn_back")
                    })
                Spacer()
                VStack {
                    Text("Vault")
                        .font(.custom("Poppins-Semibold", size: 24))
                    Text("\(photos.count) Photos")
                        .font(.custom("Poppins-Regular", size: 16))
                }.frame(width: 0.4 * screenWidth, height: 0.07 * screenHeight, alignment: .center)
                    .padding(.leading, 0)
                Spacer()
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 0.1 * screenWidth, height: 0.1 * screenWidth, alignment: .center)
                        .foregroundColor(.black)
                }.sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        let imageData = image.jpegData(compressionQuality: 1.0)
                        let image = Photo(context: moc)
                        image.imageD = imageData
                        try? moc.save()
                    }
                }
            }.padding(.horizontal, 15)
            ZStack {
                EmptyMedia()
                    .padding(0.0)
                    .frame(height: 0.6 * screenHeight, alignment: .top)
                    .opacity(photos.count != 0 ? 0 : 1)

                GeometryReader { reader in
                    ScrollView(.vertical) {
                        LazyVGrid(columns: layout) {
                            ForEach(photos, id: \.self) { photo in
                                VStack {
                                    Image(uiImage: UIImage(data: photo.imageD!)!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 0.27 * screenWidth, height: 0.17 * screenHeight, alignment: .center)
                                        .padding(.vertical, 5)
                                }
                                .onTapGesture{
                                    image = Image(uiImage: UIImage(data: photo.imageD!)!)
                                    showImageViewer.toggle()
                                        
                                }
                                .onLongPressGesture{
                                    self.moc.delete(photo)
                                    try? moc.save()
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 0.1 * screenHeight, alignment: .center)
                    }.frame(width: screenWidth, height: 0.85 * screenHeight, alignment: .bottom)
                }.opacity(photos.count == 0 ? 0 : 1)
            }
        }
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .background(Color(bgColor))
        .fullScreenCover(isPresented: $isMain, content: {
            MainView()
        })
        .fullScreenCover(isPresented: $showImageViewer, content: {
            ImageViewer(image: self.$image, viewerShown: self.$showImageViewer)
        })
    }
}

struct StorageListView_Previews: PreviewProvider {
    static var previews: some View {
        StorageListView()
    }
}

