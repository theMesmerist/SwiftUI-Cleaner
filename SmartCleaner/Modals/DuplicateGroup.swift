//
//  DuplicateGroup.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 19.06.2022.
//

import Foundation
import UIKit

class DuplicateGroup: Identifiable, Hashable {
    static func == (lhs: DuplicateGroup, rhs: DuplicateGroup) -> Bool {
        return lhs.image == rhs.image && lhs.imageArr == rhs.imageArr
    }
    

    
    @Published var image = UIImage()
    @Published var imageArr = [UIImage]()

    init(image: UIImage, imageArr: [UIImage]) {
        self.imageArr = imageArr
        self.image = image
    }
    
    init(){
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(imageArr)
    }
}

