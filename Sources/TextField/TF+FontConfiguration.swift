//
//  TF+FontConfiguration.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit


extension TextField {
    func fontConfiguration(font: UIFont?) {
        guard let font = font else { return }
        self.placeholderLabel.font = font
        switch type {
        case .listDropDown:
            dropDown.textFont = font
        case .listPicker, .searchInstant, .searchDefault:
            fullScreenDropDown.textFont = font
        default:
            return
        }
    }
}
