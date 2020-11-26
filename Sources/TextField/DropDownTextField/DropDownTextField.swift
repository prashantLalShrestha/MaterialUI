//
//  DropDownTextField.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/26/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

open class DropDownTextField: TextField {
    
    open override var delegate: UITextFieldDelegate? {
        didSet {
            if oldValue != nil {
                fatalError("TextField: delegate is already set internally.")
            }
        }
    }
    
    lazy var textFieldDelegate: UITextFieldDelegate = {
        let delegate = DropDownTextFieldDelegate()
        return delegate
    }()
    
    open override var font: UIFont? {
        didSet {
            if let font = font {
                fontConfiguration(font: font)
            }
        }
    }
    
    public var cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self)) {
        didSet {
            if cellNib != oldValue {
                dropDown.cellNib = cellNib
            }
        }
    }
    public var cellHeight = BaseDimensions.dropDownHeight {
        didSet {
            if cellHeight != oldValue {
                dropDown.cellHeight = cellHeight
            }
        }
    }
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet {
            dropDown.customCellConfiguration = customCellConfiguration
        }
    }
    public var selectionAction: SelectionClosure? {
        didSet {
            dropDown.selectionAction = selectionAction
        }
    }
    public var multiSelectionAction: MultiSelectionClosure? = nil {
        didSet {
            dropDown.multiSelectionAction = multiSelectionAction
        }
    }
    public var dataSource = [String]() {
        didSet {
            self.text = nil
            dropDown.dataSource = dataSource
            checkDataSourceStatus()
        }
    }
    public var selectedIndex: Index? {
        return dropDown.indexForSelectedRow ?? dropDown.selectedRowIndices.first
    }
    
    public lazy var dropDown: DropDown = {
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
    
    open override func makeUI() {
        super.makeUI()

        fontConfiguration(font: font)
        
        rightViewConfiguration()
        
        checkDataSourceStatus()
        
        delegate = textFieldDelegate
        
    }
}


extension DropDownTextField {
    func fontConfiguration(font: UIFont?) {
        guard let font = font else { return }
        dropDown.textFont = font
    }
    
    func rightViewConfiguration() {
        let rightViewImage = UIImage(podImageName: "icn_dropdown")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
        
        
        self.setTextFieldViewTapAction({ textField in
            self.showDropDown()
        })
    }
    
    func checkDataSourceStatus() {
        trailingViewState = dataSource.isEmpty ? .processing : .default
    }
    
    
    public func showDropDown() {
        if trailingViewState == .success {
            trailingViewState = .default
        }
        UIApplication.shared.keyWindow?.endEditing(true)
        
        dropDown.cellNib = cellNib
        dropDown.cellHeight = cellHeight
        dropDown.customCellConfiguration = customCellConfiguration
        dropDown.selectionAction = selectionAction
        dropDown.multiSelectionAction = multiSelectionAction
        let selectedRowIndices = dropDown.selectedRowIndices
        dropDown.dataSource = dataSource
        dropDown.selectedRowIndices = selectedRowIndices
        dropDown.show()
    }
}
