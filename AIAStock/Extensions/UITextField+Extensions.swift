//
//  UITextField+Extensions.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

extension UITextField {
    
    func addDoneToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([flexibleSpace, DoneButton], animated: false)
        inputAccessoryView = toolBar
    }
    
    @objc private func didTapDone() {
        resignFirstResponder()
    }
}
