//
//  CustomPlayer.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 14.06.2022.
//

import Foundation
import AVKit
import UIKit
import SwiftUI

struct CustomPlayer: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<CustomPlayer>) {
        uiViewController.player = player
    }
}
