//
//  TrailingViewState.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

public extension TextField {
    enum TrailingViewState {
        case processing
        case success
        case `default`
    }
}

extension TextField {
    func trailingViewStateConfiguration(state: TrailingViewState) {
        switch trailingViewState {
        case .default:
            setTrailingView(trailingDefaultView, mode: .always)
            trailingProcessingView.stopAnimating()
            trailingView?.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        case .processing:
            setTrailingView(trailingProcessingView, mode: .always)
            trailingProcessingView.startAnimating()
            trailingView?.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = false
        case .success:
            setTrailingView(trailingSuccessView, mode: .always)
            trailingProcessingView.stopAnimating()
            trailingView?.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
        }
    }
    
}
