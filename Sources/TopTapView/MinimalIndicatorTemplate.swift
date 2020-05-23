//
//  MinimalIndicatorTemplate.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs


public class MinimalIndicatorTemplate: NSObject, MDCTabBarIndicatorTemplate {
    public func indicatorAttributes(for context: MDCTabBarIndicatorContext) -> MDCTabBarIndicatorAttributes {
        let attributes = MDCTabBarIndicatorAttributes()
        // Outset frame, round corners, and stroke.
        let indicatorFrame = context.contentFrame.insetBy(dx: -8, dy: -4)
        
        let underlineFrame = CGRect(x: indicatorFrame.minX, y: indicatorFrame.maxY - 2.0, width: indicatorFrame.width, height: 2.0)
        let path = UIBezierPath(rect: underlineFrame)
        attributes.path = path
        return attributes
    }
}
