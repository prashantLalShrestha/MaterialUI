//
//  TF+DatePicker.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit


extension TextField {
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
