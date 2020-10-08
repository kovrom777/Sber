//
//  ViewExtension.swift
//  SberTask
//
//  Created by Роман Ковайкин on 07.10.2020.
//

import Foundation
import UIKit

extension UIView {
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
