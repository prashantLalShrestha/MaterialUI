//
//  DateTextFieldDelegate.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/27/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

internal class DateTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    override init() {
        super.init()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
