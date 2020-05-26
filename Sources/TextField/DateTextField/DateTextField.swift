//
//  DateTextField.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/27/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

open class DateTextField: TextField {
    
    open override var delegate: UITextFieldDelegate? {
        didSet {
            if oldValue != nil {
                fatalError("TextField: delegate is already set internally.")
            }
        }
    }
    
    lazy var textFieldDelegate: UITextFieldDelegate = {
        let delegate = DateTextFieldDelegate()
        return delegate
    }()
    
    public var defaultDate: Date?
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var dateSelectionAction: ((_ dateString: String?, _ date: Date?) -> Void)?
    public var dateFormat: String?
    
    
    open override func makeUI() {
        super.makeUI()
        
        rightViewConfiguration()
        
        delegate = textFieldDelegate
        
    }
}


extension DateTextField {
    
    func rightViewConfiguration() {
        let rightViewImage = UIImage(podImageName: "icn_calendar")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
        
        self.setTextFieldViewTapAction({ textField in
            self.showDatePicker()
        })
    }
    
    
    public func showDatePicker() {
        let datePicker = DatePickerDialog(textColor: self.textColor!, buttonColor: self.textColor!, font: self.font!, showCancelButton: true)
        datePicker.show(self.placeholder!, doneButtonTitle: "Set", cancelButtonTitle: "Cancel", defaultDate: defaultDate ?? Date(), minimumDate: minimumDate, maximumDate: maximumDate, datePickerMode: .date) { (date) in
            self.defaultDate = date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = date.map({ formatter.string(from: $0) })
            
            self.text = dateString
            
            self.dateSelectionAction?(dateString, date)
        }
    }
}
