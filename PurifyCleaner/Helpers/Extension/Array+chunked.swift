//
//  Array+chunked.swift
//  Cleaner
//
//  Created by Neon Apps on 19.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
