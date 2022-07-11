//
//  FileManagerUility.swift
//  storage
//
//  Created by Destan Keskinkılıç on 27.01.2022.
//

import Foundation
import UIKit

var freeDiskSpaceInBytesImportant:Int64 {
    get {
        do {
            return try URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage!
        } catch {
            return 0
        }
    }
}

