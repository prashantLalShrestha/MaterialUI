//
//  ListTextField.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/26/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

public typealias CurrentText = String
public typealias ListReloadState = ListTextField.ListReloadState
public typealias ListReloadCompletionClosure = ((ListReloadState) -> ())
public typealias ListReloadClosure = ((CurrentText?) -> ())

open class ListTextField: TextField {
    
    open override var delegate: UITextFieldDelegate? {
        didSet {
            if oldValue != nil {
                fatalError("TextField: delegate is already set internally.")
            }
        }
    }
    
    lazy var textFieldDelegate: UITextFieldDelegate = {
        let delegate = ListTextFieldDelegate()
        return delegate
    }()
    
    open override var placeholder: String? {
        didSet {
            placeholderConfiguration(placeholder: placeholder)
        }
    }
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
                fullScreenDropDown.cellNib = cellNib
            }
        }
    }
    public var cellHeight = BaseDimensions.dropDownHeight {
        didSet {
            if cellHeight != oldValue {
                fullScreenDropDown.cellHeight = cellHeight
            }
        }
    }
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet {
            fullScreenDropDown.customCellConfiguration = customCellConfiguration
        }
    }
    public var selectionAction: SelectionClosure? {
        didSet {
            fullScreenDropDown.selectionAction = selectionAction
        }
    }
    public var multiSelectionAction: MultiSelectionClosure? = nil {
        didSet {
            fullScreenDropDown.multiSelectionAction = multiSelectionAction
        }
    }
    public var dataSource = [String]() {
        didSet {
            self.text = nil
            fullScreenDropDown.dataSource = dataSource
            checkDataSourceStatus()
        }
    }
    
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
    
    open override func makeUI() {
        super.makeUI()
        
        delegate = textFieldDelegate
        
        rightViewConfiguration()
        
        checkDataSourceStatus()

        fontConfiguration(font: font)
        placeholderConfiguration(placeholder: placeholder)
        listReloadConfiguration(listFetchAction)
        
    }
    
    
    func listReloadConfiguration(_ reloadAction: ListReloadClosure?) {
        guard let reloadAction = reloadAction else { return }
        self.fullScreenDropDown.reloadAction = {
            reloadAction(nil)
        }
    }
    
    func handleReloadState(_ reloadState: ListReloadState) {
        switch reloadState {
        case .processing:
            self.trailingViewState = .processing
            fullScreenDropDown.startLoading()
        case .success:
            self.trailingViewState = .default
            fullScreenDropDown.stopLoading()
        case .failure:
            self.trailingViewState = .default
            fullScreenDropDown.stopLoading()
        }
    }
}


extension ListTextField {
    func fontConfiguration(font: UIFont?) {
        guard let font = font else { return }
        fullScreenDropDown.textFont = font
    }
    
    func placeholderConfiguration(placeholder: String?) {
        fullScreenDropDown.title = placeholder
    }
    
    private func rightViewConfiguration() {
        let rightViewImage = UIImage(podImageName: "icn_dropdown")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)
        
        
        self.setTextFieldViewTapAction({ textField in
            self.showFullScreenDropDown()
        })
    }
    
    func checkDataSourceStatus() {
        trailingViewState = dataSource.isEmpty ? .processing : .default
    }
    
    public func showFullScreenDropDown() {
        if trailingViewState == .success {
            trailingViewState = .default
        }
        UIApplication.shared.keyWindow?.endEditing(true)
        
        fullScreenDropDown.cellNib = cellNib
        fullScreenDropDown.cellHeight = cellHeight
        fullScreenDropDown.customCellConfiguration = customCellConfiguration
        fullScreenDropDown.selectionAction = selectionAction
        fullScreenDropDown.multiSelectionAction = multiSelectionAction
        let selectedRowIndices = fullScreenDropDown.selectedRowIndices
        fullScreenDropDown.dataSource = dataSource
        fullScreenDropDown.selectedRowIndices = selectedRowIndices
        fullScreenDropDown.show()
    }
}

public extension ListTextField {
    enum ListReloadState {
        case processing
        case success
        case failure
    }
}
