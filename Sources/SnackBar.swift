//
//  SnackBar.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

public class SnackBarManager {
    public static var shared: SnackBarManager {
        return singlton
    }
    private static var singlton = SnackBarManager()
    
    public init() {
        MDCSnackbarMessage.usesLegacySnackbar = true
    }
    
    let manager = MDCSnackbarManager()
    public func show(message: String, actionTitle: String, bottomOffset: CGFloat = 0.0, action: @escaping () -> ()) {
        DispatchQueue.main.async {
            let messageBar = MDCSnackbarMessage()
            let barAction = MDCSnackbarMessageAction()
            messageBar.text = message
            let actionHandler = {() in
                action()
            }
            barAction.handler = actionHandler
            barAction.title = actionTitle
            messageBar.action = barAction
            self.manager.setBottomOffset(bottomOffset)
            self.manager.show(messageBar)
        }
    }
    
    public func show(message: String, bottomOffset: CGFloat = 0.0) {
        DispatchQueue.main.async {
            let messageBar = MDCSnackbarMessage()
            messageBar.text = message
            self.manager.setBottomOffset(bottomOffset)
            self.manager.show(messageBar)
        }
        
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.manager.dismissAndCallCompletionBlocks(withCategory: nil)
        }
    }
}
