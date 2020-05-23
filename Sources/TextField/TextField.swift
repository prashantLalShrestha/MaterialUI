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
    
    public var type: TextFieldType = .default {
        didSet {
            if type != oldValue {
                textFieldTypeConfiguration(textFieldType: type)
                fontConfiguration(font: font)
                placeholderConfiguration(placeholder: placeholder)
                listReloadConfiguration(listFetchAction)
            }
        }
    }
    
    open override var delegate: UITextFieldDelegate? {
        didSet {
            switch type {
            case .listDropDown, .listPicker, .searchInstant:
                if oldValue != nil {
                    fatalError("TextField: delegate is already set internally for \(type) type.")
                }
            default:
                return
            }
        }
    }
    lazy var textFieldDelegate: UITextFieldDelegate = {
        let delegate = TextFieldTypeDelegateImpl(textFieldType: type)
        return delegate
    }()
    
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
    
    open override var placeholder: String? {
        didSet {
            placeholderConfiguration(placeholder: placeholder)
        }
    }
    open override var font: UIFont? {
        didSet {
            fontConfiguration(font: font)
        }
    }
    
    var trailingViewState: TrailingViewState = .default {
        didSet {
            if trailingViewState != oldValue {
                trailingViewStateConfiguration(state: trailingViewState)
                pickerStateConfiguration(state: trailingViewState)
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
    
    
    public var cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self)) {
        didSet {
            if cellNib != oldValue {
                setCellNib(cellNib)
            }
        }
    }
    public var cellHeight = BaseDimensions.dropDownHeight {
        didSet {
            if cellHeight != oldValue {
                setCellHeight(cellHeight)
            }
        }
    }
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet {
            setCustomCellConfiguration(customCellConfiguration)
        }
    }
    public var selectionAction: SelectionClosure? {
        didSet {
            setSelectionAction(selectionAction)
        }
    }
    public var multiSelectionAction: MultiSelectionClosure? = nil {
        didSet {
            setMultiSelectionAction(multiSelectionAction)
        }
    }
    public var dataSource = [String]() {
        didSet {
            setDataSource(dataSource)
        }
    }
    public var listFetchAction: ListReloadClosure? {
        didSet {
            listReloadConfiguration(listFetchAction)
        }
    }
    public var listReloadState: ListReloadState? {
        didSet {
            guard let listReloadState = listReloadState else { return }
            handleReloadState(listReloadState)
        }
    }
    
    lazy var dropDown: DropDown = {
        let view = DropDown()
        view.anchorView = self
        view.dismissMode = .onTap
        view.direction = .any
        view.layer.cornerRadius = BaseDimensions.cornerRadiusSmall
        view.layer.masksToBounds = true
        view.cellHeight = cellHeight
        view.cancelAction = {
            self.delegate?.textFieldDidEndEditing?(self)
        }
        return view
    }()
    lazy var fullScreenDropDown: FullScreenDropDown = {
        let view = FullScreenDropDown()
        view.layer.cornerRadius = BaseDimensions.cornerRadiusSmall
        view.layer.masksToBounds = true
        view.cellHeight = cellHeight
        view.cancelAction = {
            self.delegate?.textFieldDidEndEditing?(self)
        }
        return view
    }()
    var disabledView: UIView?
    
    public var defaultDate: Date?
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var dateSelectionAction: ((_ dateString: String?, _ date: Date?) -> Void)?
    public var dateFormat: String?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
}

extension TextField {
    open func makeUI() {
        self.layer.masksToBounds = true
        
        self.style = .filled
        
        fontConfiguration(font: font)
        placeholderConfiguration(placeholder: placeholder)
        
        self.setEventTargets()
    }
}



