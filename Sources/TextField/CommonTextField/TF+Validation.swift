//
//  TF+Validation.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import Foundation

public extension TextField {
    @discardableResult func checkValidation(_ regex: String? = nil, emptyErrorText: String? = nil, invalidErrorText: String? = nil) -> Bool {
        
        var isValid = false
//        defer {
//            trailingViewState = isValid ? .success : .default
//        }
        
        guard let text = text, !text.isEmpty else {
            self.setErrorText(emptyErrorText ?? "Required Field*", errorAccessibilityValue: nil)
            isValid = false
            return isValid
        }
        
        guard let regex = regex else {
            self.setErrorText(nil, errorAccessibilityValue: nil)
            isValid = true
            return isValid
        }
        
        isValid = text.isValid(regex: regex)
        let invalidErrorText = invalidErrorText ?? "Invalid Input"
        self.setErrorText(isValid ? nil : invalidErrorText, errorAccessibilityValue: nil)
        
        return isValid
    }
    
    func setErrorText(_ errorText: String?, errorAccessibilityValue: String?) {
        if style == .common {
            if errorText?.isEmpty == false {
                commonBorderView.layer.borderColor = controller?.errorColor.cgColor
            } else {
                commonBorderView.layer.borderColor = isEditing ? controller?.activeColor.cgColor : controller?.normalColor.cgColor
            }
        }
        controller?.setErrorText(errorText, errorAccessibilityValue: errorAccessibilityValue)
    }
    
    func setHelperText(_ helperText: String?, helperAccessibilityValue: String?) {
        if style == .common {
            commonBorderView.layer.borderColor = isEditing ? controller?.activeColor.cgColor : controller?.normalColor.cgColor
        }
        controller?.setHelperText(helperText, helperAccessibilityLabel: helperAccessibilityValue)
    }
}


fileprivate extension String {
    func isValid(regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: self)
        return result
    }
}
