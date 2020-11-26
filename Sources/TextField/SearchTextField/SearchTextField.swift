//
//  SearchTextField.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/26/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

open class SearchTextField: TextField {
    
    open override var delegate: UITextFieldDelegate? {
        didSet {
            if oldValue != nil && searchType == .instant {
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
            fullScreenDropDown.dataSource = dataSource
        }
    }
    public var selectedIndex: Index? {
        return fullScreenDropDown.indexForSelectedRow ?? fullScreenDropDown.selectedRowIndices.first
    }
    
    public lazy var fullScreenDropDown: FullScreenDropDown = {
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
    
    public var searchType: SearchType = .default {
        didSet {
            if searchType == .instant {
                delegate = textFieldDelegate
            }
            listReloadConfiguration(listFetchAction)
        }
    }
    
    open override func makeUI() {
        super.makeUI()
        
        if searchType == .instant {
            delegate = textFieldDelegate
        }
        
        rightViewConfiguration()

        fontConfiguration(font: font)
        placeholderConfiguration(placeholder: placeholder)
        listReloadConfiguration(listFetchAction)
    }
    
    func listReloadConfiguration(_ reloadAction: ListReloadClosure?) {
        guard let reloadAction = reloadAction else { return }
        switch searchType {
        case .default:
            self.setTrailingViewTapAction({ textField in
                if textField.text?.isEmpty == false {
                    reloadAction(textField.text)
                }
            })
        case .instant:
            self.fullScreenDropDown.searchAction = { searchText in
                if searchText.isEmpty == false {
                    reloadAction(searchText)
                }
            }
            self.setTextFieldViewTapAction({ textField in
                self.dataSource = []
                self.showFullScreenDropDown()
                self.fullScreenDropDown.searchBar.becomeFirstResponder()
                self.fullScreenDropDown.searchBar.text = self.text
                self.fullScreenDropDown.searchAction?(self.text ?? "")
            })
        }
    }
    
    func handleReloadState(_ reloadState: SearchTextField.ListReloadState) {
        switch reloadState {
        case .processing:
            self.trailingViewState = .processing
            fullScreenDropDown.startLoading()
        case .success  where searchType == .default:
            self.trailingViewState = .default
            fullScreenDropDown.stopLoading()
            self.showFullScreenDropDown()
        case .success:
            self.trailingViewState = .default
            fullScreenDropDown.stopLoading()
        case .failure:
            self.trailingViewState = .default
            fullScreenDropDown.stopLoading()
        }
    }
}


extension SearchTextField {
    func rightViewConfiguration() {
        
        let rightViewImage = UIImage(podImageName: "icn_search")?.scaled()?.withRenderingMode(.alwaysTemplate)
        
        let rightViewImageView = UIImageView(image: rightViewImage)
        rightViewImageView.tintColor = textColor
        
        self.setTrailingView(rightViewImageView)

    }
}


extension SearchTextField {
    func fontConfiguration(font: UIFont?) {
        guard let font = font else { return }
        fullScreenDropDown.textFont = font
    }
    
    func placeholderConfiguration(placeholder: String?) {
        fullScreenDropDown.title = placeholder
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

public extension SearchTextField {
    enum ListReloadState {
        case processing
        case success
        case failure
    }
}
