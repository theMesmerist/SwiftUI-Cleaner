//
//  Globals.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 1.06.2022.
//

import Foundation
import SwiftUI
import PhotosUI

var isUserPremium = false
let Main_Password = "com.neonapps.mainpassword"
let FaceID_Active = "com.neonapps.mainpassword.faceidactive"
var screenHeight = UIScreen.main.bounds.height
var screenWidth = UIScreen.main.bounds.width

var allScreenshot = [ImageObject]()

var isAlert = true
let uDefaults = UserDefaults.standard

var screenH = CGFloat()
var screenW = CGFloat()
var stringMultiplier = CGFloat()

var allLargeVideos = [Videos]()

var screenShotsWillDelete = [URL]()
var sender = ""

func setDefaultSize(view: UIView) {
    screenH = view.frame.size.height
    screenW = view.frame.size.width
    stringMultiplier = 0.00115 * screenHeight
}

func setUserDefaultsValue(_ value: Any, _ key: String)
{
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultsValue(_ key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func getUserDefaultsValue(_ key: String) -> Any?
{
    return UserDefaults.standard.value(forKey: key)
}

func setUserDefaultsBoolValue(_ value: Bool, _ key: String)
{
    print("___________\(key)______________")
    print(value)
    print("_________________________")
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}
func getUserDefaultsBoolValue(_ key: String) -> Bool
{
    if (UserDefaults.standard.value(forKey: key) != nil) {
        print("___________\(key)______________")
        print(UserDefaults.standard.value(forKey: key) as! Bool)
        print("_________________________")
        return UserDefaults.standard.value(forKey: key) as! Bool
    } else {
        print("___________\(key)______________")
        print("nill")
        print("_________________________")
        return false
    }
}

func requestPermission() {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        switch status {
        case .notDetermined: break
            // The user hasn't determined this app's access.
        case .restricted: break
            // The system restricted this app's access.
        case .denied: break
            // The user explicitly denied this app's access.
        case .authorized: break
            // The user authorized this app to access Photos data.
        case .limited: break
            // The user authorized this app for limited Photos access.
        @unknown default:
            fatalError()
        }
    }
}

var freeDiskSpaceInBytesImportant:Int64 {
    get {
        do {
            return try URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage!
        } catch {
            return 0
        }
    }
}


