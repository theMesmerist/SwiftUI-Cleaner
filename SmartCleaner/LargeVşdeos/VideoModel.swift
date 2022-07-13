//
//  VideoModel.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 14.06.2022.
//

import Foundation


class Video{
    var videoUrl : URL
    var videoSize : Int
    
    init(videoUrl : URL, videoSize : Int){
        self.videoUrl = videoUrl
        self.videoSize = videoSize
    }
}
