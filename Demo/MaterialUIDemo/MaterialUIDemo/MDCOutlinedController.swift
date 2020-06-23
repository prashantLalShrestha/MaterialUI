//
//  MDCOutlinedController.swift
//  MaterialUIDemo
//
//  Created by Prashant Shrestha on 6/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents

fileprivate let MDCTextInputOutlinedTextFieldFullPadding: CGFloat = 16
fileprivate let MDCTextInputOutlinedTextFieldNormalPlaceholderPadding: CGFloat = 8
fileprivate let MDCTextInputOutlinedTextFieldThreeQuartersPadding: CGFloat = 12

class MDCOutlinedController: MDCTextInputControllerOutlined {
    
    required init(textInput input: (UIView & MDCTextInput)?) {
        super.init(textInput: input)
        
//        input?.textInsetsMode = .always
//        
//        self.isFloatingEnabled = false
    }
    
    
    override func leadingViewRect(forBounds bounds: CGRect, defaultRect: CGRect) -> CGRect {
        var leadingViewRect = defaultRect
        let xOffset = MDCTextInputOutlinedTextFieldFullPadding
        
        leadingViewRect = leadingViewRect.offsetBy(dx: xOffset, dy: 0)
        
        let borderRect = self.borderRect
        leadingViewRect.origin.y = borderRect.minY + borderRect.height / 2 - leadingViewRect.height / 2
        
        return leadingViewRect
    }
    
    override func leadingViewTrailingPaddingConstant() -> CGFloat {
        return MDCTextInputOutlinedTextFieldFullPadding
    }
    
    override func trailingViewRect(forBounds bounds: CGRect, defaultRect: CGRect) -> CGRect {
        var trailingViewRect = defaultRect
        let xOffset = -MDCTextInputOutlinedTextFieldThreeQuartersPadding
        
        trailingViewRect = trailingViewRect.offsetBy(dx: xOffset, dy: 0)
        
        let borderRect = self.borderRect
        trailingViewRect.origin.y = borderRect.minY + borderRect.height / 2 + trailingViewRect.height / 2
        
        return trailingViewRect
    }
    
    override func trailingViewTrailingPaddingConstant() -> CGFloat {
        return MDCTextInputOutlinedTextFieldThreeQuartersPadding
    }
    
    override func textInsets(_ defaultInsets: UIEdgeInsets, withSizeThatFitsWidthHint widthHint: CGFloat) -> UIEdgeInsets {
        var defaultInsets = defaultInsets
        defaultInsets.left = MDCTextInputOutlinedTextFieldFullPadding
        defaultInsets.right = MDCTextInputOutlinedTextFieldFullPadding
        var textInset = super.textInsets(defaultInsets, withSizeThatFitsWidthHint: widthHint)
        let textVerticalOffset = self.textInput!.placeholderLabel.font.lineHeight * 0.5
        
        let scale = UIScreen.main.scale
        let placeholderEstimatedHeight = MDCCeil(self.textInput!.placeholderLabel.font.lineHeight * scale) / scale
        textInset.top = self.borderHeight - MDCTextInputOutlinedTextFieldFullPadding - placeholderEstimatedHeight + textVerticalOffset
        
        return textInset
    }
    
    // MARK: - MDCTextInputControllerBase overrides
    func updateLayout() {
        
    }
    
    
    
    private var borderRect: CGRect {
        var pathRect = self.textInput!.bounds
        pathRect.origin.y = pathRect.origin.y + self.textInput!.placeholderLabel.font.lineHeight * 0.5
        pathRect.size.height = self.borderHeight
        return pathRect
    }
    
    private var borderHeight: CGFloat {
        let scale = UIScreen.main.scale
        let placeholderEstimatedHeight = MDCCeil(self.textInput!.placeholderLabel.font.lineHeight * scale) / scale
        return MDCTextInputOutlinedTextFieldNormalPlaceholderPadding + placeholderEstimatedHeight + MDCTextInputOutlinedTextFieldNormalPlaceholderPadding
    }
    
}
