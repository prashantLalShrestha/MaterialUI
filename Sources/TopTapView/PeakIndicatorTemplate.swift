//
//  PeakIndicatorTemplate.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs

public class PeakIndicatorTemplate: NSObject, MDCTabBarIndicatorTemplate {
    public func indicatorAttributes(for context: MDCTabBarIndicatorContext) -> MDCTabBarIndicatorAttributes {
        let attributes = MDCTabBarIndicatorAttributes()
        // Outset frame, round corners, and stroke.
        let indicatorFrame = context.contentFrame
        
        let triangleFrame = CGRect(x: indicatorFrame.midX - 14, y: indicatorFrame.maxY + 4, width: 28, height: 16)
        let path = UIBezierPath()

        path.move(to: CGPoint(x: triangleFrame.minX, y: triangleFrame.maxY))
        path.addLine(to: CGPoint(x: triangleFrame.maxX, y: triangleFrame.maxY))
        path.addLine(to: CGPoint(x: triangleFrame.midX, y: triangleFrame.minY))
        path.addLine(to: CGPoint(x: triangleFrame.minX, y: triangleFrame.maxY))
        path.close()
        
        attributes.path = path
        return attributes
    }
}
