//
//  Extensions.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 1.06.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    } }


extension Dictionary where Key == String, Value == Any {

    mutating func append(anotherDict: [String: Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}


