//
//  Formatter.swift
//  ChoosePhoto
//
//  Created by Developer on 07/07/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

class Formatter {
    class func humanReadableByteCount(bytes: Int) -> String {
        guard bytes > 1000 else { return "\(bytes) B"}

        let exp = Int(log2(Double(bytes)) / log2(1000.0))
        let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
        let number = Double(bytes) / pow(1000, Double(exp))
        if exp <= 1 || number >= 100 {
            return String(format: "%.0f %@", number, unit)
        } else {
            return String(format: "%.1f %@", number, unit).replacingOccurrences(of: ".0", with: "")
        }
    }
    
    class func convertDateToStringDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    class func makeStringFromArrayOfArray(array: [[ImageObject]]) -> String {
        var fullSize = 0
        for i in array {
            for j in i {
                fullSize += j.size
            }
        }
        return humanReadableByteCount(bytes: fullSize)
    }
}
