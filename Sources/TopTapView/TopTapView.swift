//
//  TopTapView.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs


open class TopTabView: MDCTabBar {
    
    public var didSelectItem: ((Int, UITabBarItem) -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.selectionIndicatorTemplate = MinimalIndicatorTemplate()
        self.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TopTabView: MDCTabBarDelegate {
    public func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        var selectedIndex = 0
        for i in 0...tabBar.items.count - 1 {
            if item == tabBar.items[i] {
                selectedIndex = i
                break
            }
        }
        self.didSelectItem?(selectedIndex, item)
    }
}

