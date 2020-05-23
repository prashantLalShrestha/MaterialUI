//
//  TF+SecureTextConfiguration.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit



extension TextField {
    override open func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        guard isSecureTextEntry else {
            return super.target(forAction: action, withSender: sender)
        }
        
        if #available(iOS 10, *) {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return nil
            }
        } else {
            if action == #selector(paste(_:)) {
                return nil
            }
        }
        
        return super.target(forAction: action, withSender: sender)
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard isSecureTextEntryToggleEnabled || isSecureTextEntry else {
            return super.canPerformAction(action, withSender: nil)
        }
        
        return false
    }
    
    func secureTextEntryRightViewConfiguration() {
        guard isSecureTextEntryToggleEnabled else { return }
        let rightViewImage = UIImage(podImageName: isSecureTextEntry ? "icn_eye_closed" : "icn_eye_opened")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
        
        self.setTrailingViewTapAction({ textField in
            textField.isSecureTextEntry = !textField.isSecureTextEntry
        })
    }
    
    func secureTextEndEditing() {
        if isSecureTextEntryToggleEnabled == true && isSecureTextEntry == false {
            isSecureTextEntry = true
        }
    }
}
