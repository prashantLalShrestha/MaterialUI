//
//  OutlinedTextView.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

open class OutlinedTextView: UIView {
    
    private lazy var _textView: TextView = {
        let view = TextView()
        return view
    }()
    
    public weak var textView: UITextView? {
        return _textView.textView
    }
    
    public var text: String? {
        get {
            return _textView.text
        }
        set {
            _textView.text = newValue
        }
    }
    
    public var placeholder: String? {
        get {
            return _textView.placeholder
        }
        set {
            _textView.placeholder = newValue
        }
    }
    
    public var font: UIFont? {
        get {
            return _textView.font
        }
        set {
            _textView.font = newValue
            _textView.placeholderLabel.font = newValue
            _textView.controller?.inlinePlaceholderFont = newValue
        }
    }
    
    open override var tintColor: UIColor! {
        didSet {
            _textView.tintColor = tintColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        applyTheme()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
        applyTheme()
    }
    
    open func makeUI() {
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = BaseDimensions.cornerRadiusSmall
        self.layer.borderWidth = 1.0
        _textView.placeholderLabel.numberOfLines = 0
        _textView.controller?.isFloatingEnabled = false
        
        
        self.addSubview(_textView)
        _textView.translatesAutoresizingMaskIntoConstraints = false
        _textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaseDimensions.inset).isActive = true
        _textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaseDimensions.inset).isActive = true
        _textView.topAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
        _textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
    }
    
    
    func applyTheme() {
        self.layer.borderColor = UIColor.darkText.withAlphaComponent(0.36).cgColor
        self._textView.underline?.isHidden = true
        self._textView.controller?.normalColor = UIColor.lightText
        self._textView.controller?.activeColor = UIColor.darkText
        self._textView.controller?.underlineViewMode = .never
        self._textView.underline?.color = UIColor.clear
        self._textView.controller?.underlineHeightNormal = 0.0
        self._textView.controller?.underlineHeightActive = 0.0
        self._textView.controller?.textInput?.underline?.color = UIColor.clear
    }
    
}
