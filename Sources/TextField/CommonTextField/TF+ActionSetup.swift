//
//  TF+ActionSetup.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit


public extension TextField {
    func setLeadingView(view: UIView? = nil, mode: UITextField.ViewMode = .always) {
        self.leadingView = view
        self.leadingViewMode = mode

        self.leadingView?.isUserInteractionEnabled = false
    }
    
    func setTrailingView(_ view: UIView? = nil, mode: UITextField.ViewMode = .always) {
        self.trailingView = view
        self.trailingViewMode = mode
        
        if trailingViewState == .default {
            self.trailingDefaultView = view
        }

        self.trailingView?.isUserInteractionEnabled = false
    }
    
    func setLeadingViewTapAction(_ action: ((TextField) -> ())? = nil) {
        guard let leadingView = leadingView else { return }
        self.leadingViewAction = action
        if action != nil {
            leadingView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(leadingViewTapAction))
            
            leadingView.gestureRecognizers?.forEach({ (gestureRecognizer) in
                leadingView.removeGestureRecognizer(gestureRecognizer)
            })
            leadingView.addGestureRecognizer(tapGesture)
        } else {
            leadingView.isUserInteractionEnabled = false
            leadingView.gestureRecognizers?.forEach({ (gestureRecognizer) in
                leadingView.removeGestureRecognizer(gestureRecognizer)
            })
        }
    }
    
    @objc private func leadingViewTapAction() {
        leadingViewAction?(self)
    }
    
    func setTrailingViewTapAction(_ action: ((TextField) -> ())? = nil) {
        guard let trailingView = trailingView else { return }
        self.trailingViewAction = action
        if action != nil {
            trailingView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trailingViewTapAction))
            
            trailingView.gestureRecognizers?.forEach({ (gestureRecognizer) in
                trailingView.removeGestureRecognizer(gestureRecognizer)
            })
            trailingView.addGestureRecognizer(tapGesture)
        } else {
            trailingView.isUserInteractionEnabled = false
            trailingView.gestureRecognizers?.forEach({ (gestureRecognizer) in
                trailingView.removeGestureRecognizer(gestureRecognizer)
            })
        }
    }
    
    @objc private func trailingViewTapAction() {
        trailingViewAction?(self)
    }
    
    func setTextFieldViewTapAction(_ action: ((TextField) -> ())? = nil) {
        guard let textFieldViewAction = action else {
            self.textFieldViewAction = nil
            disableView(false)
            return
        }

        self.textFieldViewAction = textFieldViewAction

        disableView(true)

        guard let disableView = disabledView else { return }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldViewTapAction))

        disableView.gestureRecognizers?.forEach({ (gestureRecognizer) in
            disableView.removeGestureRecognizer(gestureRecognizer)
        })
        disableView.addGestureRecognizer(tapGesture)
        
        self.setTrailingViewTapAction({ _ in
            self.textFieldViewTapAction()
        })
        self.setLeadingViewTapAction({ _ in
            self.textFieldViewTapAction()
        })
    }
    
    @objc private func textFieldViewTapAction() {
        textFieldViewAction?(self)
    }
    
    func disableView(_ shouldDisable: Bool) {
        if shouldDisable {
            let disabledView = UIView()
            self.addSubview(disabledView)
            disabledView.translatesAutoresizingMaskIntoConstraints = false
            let disableViewConstraints = [
                disabledView.topAnchor.constraint(equalTo: topAnchor),
                disabledView.bottomAnchor.constraint(equalTo: bottomAnchor),
                disabledView.leftAnchor.constraint(equalTo: leftAnchor),
                disabledView.rightAnchor.constraint(equalTo: rightAnchor),
            ]
            NSLayoutConstraint.activate(disableViewConstraints)
            self.disabledView = disabledView
        } else {
            disabledView?.removeFromSuperview()
        }
    }
}

