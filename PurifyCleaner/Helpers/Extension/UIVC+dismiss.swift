//
//  UIVC+dismiss.swift
//  Cleaner
//
//  Created by Neon Apps on 25.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
