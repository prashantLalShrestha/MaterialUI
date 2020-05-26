//
//  DropDownTextFieldDelegate.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/26/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

internal class DropDownTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    override init() {
        super.init()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
