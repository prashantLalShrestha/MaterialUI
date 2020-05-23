//
//  TextView.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import MaterialComponents.MaterialTextFields
import UIKit

open class TextView: MDCMultilineTextField {
    
    public var controller: MDCTextInputControllerUnderline?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        materialConfig()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
        materialConfig()
    }
    
    
    override public var placeholder: String? {
        didSet {
        }
    }
    
    public func makeUI() {
        layer.masksToBounds = true
        
    }
    
    func materialConfig() {
        controller = MDCTextInputControllerUnderline(textInput: self)
        controller?.isFloatingEnabled = true
        controller?.textInput?.underline?.backgroundColor = UIColor.black
        
        textView?.delegate = self
        
//        controller?.textInputFont = UIFont.regularRegular
        controller?.underlineHeightActive = 1.5
//        controller?.inlinePlaceholderFont = UIFont.regularRegular
        controller?.underlineHeightNormal = 1.5
        
    }
    
}

extension TextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let string = text
        if string == "" || string == nil {
            self.controller?.underlineViewMode = .whileEditing
        } else {
            self.controller?.underlineViewMode = .always
        }
    }
}
