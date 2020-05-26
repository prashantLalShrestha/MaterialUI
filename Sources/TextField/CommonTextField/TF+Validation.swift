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
            self.controller?.setErrorText(emptyErrorText ?? "Required Field*", errorAccessibilityValue: nil)
            isValid = false
            return isValid
        }
        
        guard let regex = regex else {
            self.controller?.setErrorText(nil, errorAccessibilityValue: nil)
            isValid = true
            return isValid
        }
        
        isValid = text.isValid(regex: regex)
        let invalidErrorText = invalidErrorText ?? "Invalid Input"
        self.controller?.setErrorText(isValid ? nil : invalidErrorText, errorAccessibilityValue: nil)
        
        return isValid
    }
}


fileprivate extension String {
    func isValid(regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: self)
        return result
    }
}
