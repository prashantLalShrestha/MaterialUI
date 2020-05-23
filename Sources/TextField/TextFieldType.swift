//
//  TextFieldType.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

public extension TextField {
    enum TextFieldType {
        case `default`
        case listDropDown
        case listPicker
        case searchDefault
        case searchInstant
        case date
    }
}

extension TextField {
    
    func textFieldTypeConfiguration(textFieldType: TextFieldType) {
        switch textFieldType {
        case .listDropDown:
            listDropDownRightViewConfiguration()
            checkDataSourceStatus()
            delegate = textFieldDelegate
        case .listPicker:
            listPickerRightViewConfiguration()
            checkDataSourceStatus()
            delegate = textFieldDelegate
        case .searchDefault:
            searchRightViewConfigurartion()
        case .searchInstant:
            searchRightViewConfigurartion()
            delegate = textFieldDelegate
        case .date:
            dateRightViewConfiguration()
        default:
            return
        }
    }
    
}

extension TextField {
    func listDropDownRightViewConfiguration() {
        pickerRightViewConfiguration()
        
        self.setTextFieldViewTapAction({ textField in
            self.showDropDown()
        })
    }
    
    
    func listPickerRightViewConfiguration() {
        pickerRightViewConfiguration()
        
        self.setTextFieldViewTapAction({ textField in
            self.showFullScreenDropDown()
        })
    }
    
    private func pickerRightViewConfiguration() {
        let rightViewImage = UIImage(podImageName: "icn_dropdown")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
    }
    
    func searchRightViewConfigurartion() {
        let rightViewImage = UIImage(podImageName: "icn_search")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
    }
    
    func dateRightViewConfiguration() {
        let rightViewImage = UIImage(podImageName: "icn_calendar")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
        
        self.setTextFieldViewTapAction({ _ in
            self.showDatePicker()
        })
    }
}
