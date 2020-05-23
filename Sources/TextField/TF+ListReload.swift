//
//  TF+ListReload.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

public typealias CurrentText = String
public typealias ListReloadState = TextField.ListReloadState
public typealias ListReloadCompletionClosure = ((ListReloadState) -> ())
public typealias ListReloadClosure = ((CurrentText?) -> ())

public extension TextField {
    enum ListReloadState {
        case processing
        case success
        case failure
    }
    
    
    func listReloadConfiguration(_ reloadAction: ListReloadClosure?) {
        guard let reloadAction = reloadAction else { return }
        switch type {
        case .searchDefault:
            self.setTrailingViewTapAction({ textField in
                if textField.text?.isEmpty == false {
                    reloadAction(textField.text)
                }
            })
            break
        case .searchInstant:
            self.fullScreenDropDown.searchAction = { searchText in
                if searchText.isEmpty == false {
                    reloadAction(searchText)
                }
            }
            self.setTextFieldViewTapAction({ textField in
                self.dataSource = []
                self.showFullScreenDropDown()
                self.fullScreenDropDown.searchBar.becomeFirstResponder()
            })
            break
        case .listPicker:
            self.fullScreenDropDown.reloadAction = {
                reloadAction(nil)
            }
        default:
            return
        }
    }
    
    func handleReloadState(_ reloadState: ListReloadState) {
        switch reloadState {
        case .processing:
            self.trailingViewState = .processing
        case .success where type == .searchDefault:
            self.trailingViewState = .default
            self.showFullScreenDropDown()
        case .success:
            self.trailingViewState = .default
        case .failure:
            self.trailingViewState = .default
        }
    }
}
