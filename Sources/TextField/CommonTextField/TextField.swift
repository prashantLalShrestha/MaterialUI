//
//  TextField.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

@IBDesignable
open class TextField: MDCTextField {
    
    public var controller: MDCTextInputControllerBase?
    
    public var style: TextFieldStyle = .underlined {
        didSet {
            if style != oldValue {
                materialConfiguration(style: style)
            }
        }
    }
    
    public override var isSecureTextEntry: Bool {
        didSet {
            secureTextEntryRightViewConfiguration()
        }
    }
    public var isSecureTextEntryToggleEnabled: Bool = false {
        didSet {
            self.isSecureTextEntry = true
        }
    }
    
    open override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = font
        }
    }
    
    var trailingViewState: TrailingViewState = .default {
        didSet {
            if trailingViewState != oldValue {
                trailingViewStateConfiguration(state: trailingViewState)
            }
        }
    }
    var trailingDefaultView: UIView?
    lazy var trailingProcessingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.tintColor = textColor
        return view
    }()
    lazy var trailingSuccessView: UIImageView = {
        let image = UIImage(podImageName: "icn_tick")?.scaled()?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = textColor
        return view
    }()
    
    var leadingViewAction: ((TextField) -> ())?
    var trailingViewAction: ((TextField) -> ())?
    var textFieldViewAction: ((TextField) -> ())?
    
    var disabledView: UIView?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    
    open func makeUI() {
        self.layer.masksToBounds = true
        
        self.placeholderLabel.font = font
        
        self.setEventTargets()
    }
}



