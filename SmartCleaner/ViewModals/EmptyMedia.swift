//
//  EmptyMedia.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 9.06.2022.
//

import SwiftUI
import MediaBrowser
import CoreData

struct EmptyMedia: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State var isEmpty = false

    var body: some View {
        VStack {
            Text("No Storage Files").font(.custom("Poppins-Regular", size: 32))
                .foregroundColor(Color(UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)))
            Spacer()
            Text("Click the **Add** button to add secret photos and videos")
                .font(.custom("Poppins-Light", size: 24))
                .foregroundColor(Color(UIColor.systemGray))
                .multilineTextAlignment(.center)
            Spacer().frame(height: 0.08 * screenHeight, alignment: .center)
            Button {
                showImagePicker.toggle()
            } label: {
                Text("+ Add")
                    .frame(width: 0.6 * screenWidth, height: 0.06 * screenHeight, alignment: .center)
                    .font(.custom("Poppins-Medium", size: 20))
            }.frame(width: 0.6 * screenWidth, height: 0.06 * screenHeight, alignment: .center)
                .background(Color(purpleColor))
                .foregroundColor(.white)

        }.frame(height: 0.3 * screenHeight, alignment: .center)
            .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                let imageData = image.jpegData(compressionQuality: 1.0)
                let image = Photo(context: moc)
                image.imageD = imageData
                try? moc.save()

            }
        }
    }
}

struct EmptyMedia_Previews: PreviewProvider {
    static var previews: some View {
        EmptyMedia()
    }
}

