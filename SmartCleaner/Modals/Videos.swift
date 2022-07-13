//
//  Videos.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 3.06.2022.
//

import Foundation
import SwiftUI

class Videos : Identifiable{
    @Published var videoUrl : String = ""
    @Published var size : Int = 0
    
    
    
    init(name : String, ImageName : String, size: Int, isSelected : Bool, videoUrl : String) {
        self.size = size
        self.videoUrl = videoUrl
        
    }
    
    init() {
        
    }
    static var allVideos: [Videos] = []
    
}
