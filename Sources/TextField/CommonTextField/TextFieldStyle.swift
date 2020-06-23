//
//  TextFieldStyle.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

public extension TextField {
    enum TextFieldStyle {
        case underlined
        case outlined
        case filled
        case common
    }
}

extension TextField {
    func materialConfiguration(style: TextFieldStyle) {
        switch style {
        case .filled:
            controller = MDCTextInputControllerFilled(textInput: self)
        case .underlined:
            controller = MDCTextInputControllerUnderline(textInput: self)
        case .outlined:
            controller = MDCTextInputControllerOutlined(textInput: self)
        case .common:
            controller = MDCTextInputControllerFilled(textInput: self)
            controller?.isFloatingEnabled = false
            controller?.borderFillColor = UIColor.clear
            controller?.normalColor = placeholderLabel.textColor
            controller?.underlineHeightActive = 0.0
            controller?.underlineHeightNormal = 0.0
            configCommonBorderView()
            
            self.addTarget(self, action: #selector(commonBorderViewEditing), for: .editingDidBegin)
            self.addTarget(self, action: #selector(commonBorderViewEditingEnd), for: .editingDidEnd)
            
        }
    }
    
    func configCommonBorderView() {
        if self.subviews.contains(commonBorderView) == false, let underline = self.underline {
            self.insertSubview(commonBorderView, at: 0)
            commonBorderView.translatesAutoresizingMaskIntoConstraints = false
            commonBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
            commonBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
            commonBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
            commonBorderView.bottomAnchor.constraint(equalTo: underline.bottomAnchor, constant: -8.0).isActive = true
            
            commonBorderView.layer.borderColor = controller?.normalColor.cgColor
            commonBorderView.layer.borderWidth = 1.0
            commonBorderView.layer.cornerRadius = 4.0
            
            leadingUnderlineLabel.translatesAutoresizingMaskIntoConstraints = false
            leadingUnderlineLabel.topAnchor.constraint(equalTo: commonBorderView.bottomAnchor, constant: 2.0).isActive = true
            leadingUnderlineLabel.leftAnchor.constraint(equalTo: commonBorderView.leftAnchor, constant: 8.0).isActive = true
            leadingUnderlineLabel.rightAnchor.constraint(equalTo: commonBorderView.rightAnchor, constant: 8.0).isActive = true
            
            trailingUnderlineLabel.translatesAutoresizingMaskIntoConstraints = false
            trailingUnderlineLabel.topAnchor.constraint(equalTo: commonBorderView.bottomAnchor, constant: 2.0).isActive = true
            trailingUnderlineLabel.leftAnchor.constraint(equalTo: commonBorderView.leftAnchor, constant: 8.0).isActive = true
            trailingUnderlineLabel.rightAnchor.constraint(equalTo: commonBorderView.rightAnchor, constant: 8.0).isActive = true
            
            
            self.layoutIfNeeded()
        }
    }
    
    
    @objc func commonBorderViewEditing() {
        if style == .common && controller?.errorText?.isEmpty == true {
            commonBorderView.layer.borderColor = controller?.activeColor.cgColor
        }
    }
    
    @objc func commonBorderViewEditingEnd() {
        if style == .common && controller?.errorText?.isEmpty == true {
            commonBorderView.layer.borderColor = controller?.normalColor.cgColor
        }
    }
}
