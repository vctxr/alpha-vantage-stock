//
//  UIAlertController.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

extension UIAlertController {
    
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
