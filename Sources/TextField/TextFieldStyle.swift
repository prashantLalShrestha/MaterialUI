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
        }
    }
}
