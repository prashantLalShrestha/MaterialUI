//
//  TF+PlaceholderConfiguration.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit


extension TextField {
    func placeholderConfiguration(placeholder: String?) {
        switch type {
        case .listPicker, .searchInstant, .searchDefault:
            fullScreenDropDown.title = placeholder
        default:
            return
        }
    }
}
