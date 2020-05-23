//
//  TextFieldTypeDelegate.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit


internal class TextFieldTypeDelegateImpl: NSObject, UITextFieldDelegate {
    let textFieldType: TextField.TextFieldType
    
    init(textFieldType: TextField.TextFieldType) {
        self.textFieldType = textFieldType
        super.init()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textFieldType {
        case .default, .searchDefault:
            return true
        default:
            return false
        }
    }
}
