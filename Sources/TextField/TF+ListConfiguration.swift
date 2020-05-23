//
//  TF+ListConfiguration.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit



extension TextField {
    func setCellNib(_ nib: UINib) {
        switch type {
        case .listDropDown:
            dropDown.cellNib = cellNib
        case .listPicker:
            fullScreenDropDown.cellNib = cellNib
        default:
            return
        }
    }
    func setCellHeight(_ cellHeight: CGFloat) {
        switch type {
        case .listDropDown:
            dropDown.cellHeight = cellHeight
        case .listPicker:
            fullScreenDropDown.cellHeight = cellHeight
        default:
            return
        }
    }
    
    func setCustomCellConfiguration(_ customCellConfiguration: CellConfigurationClosure?) {
        switch type {
        case .listDropDown:
            dropDown.customCellConfiguration = customCellConfiguration
        case .listPicker:
            fullScreenDropDown.customCellConfiguration = customCellConfiguration
        default:
            return
        }
    }
    
    func setSelectionAction(_ selectionAction: SelectionClosure?) {
        switch type {
        case .listDropDown:
            dropDown.selectionAction = selectionAction
        case .listPicker:
            fullScreenDropDown.selectionAction = selectionAction
        default:
            return
        }
    }
    
    func setMultiSelectionAction(_ multiSelectionAction: MultiSelectionClosure?) {
        switch type {
        case .listDropDown:
            dropDown.multiSelectionAction = multiSelectionAction
        case .listPicker:
            fullScreenDropDown.multiSelectionAction = multiSelectionAction
        default:
            return
        }
    }
    
    func setDataSource(_ dataSource: [String]) {
        switch type {
        case .listDropDown:
            self.text = nil
            dropDown.dataSource = dataSource
            checkDataSourceStatus()
        case .listPicker, .searchDefault, .searchInstant:
            self.text = nil
            fullScreenDropDown.dataSource = dataSource
            checkDataSourceStatus()
        default:
            return
        }
    }
    
    func checkDataSourceStatus() {
        switch type {
        case .listDropDown, .listPicker:
            trailingViewState = dataSource.isEmpty ? .processing : .default
        default:
            return
        }
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
