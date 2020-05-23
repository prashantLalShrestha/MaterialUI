//
//  UINib+Ext.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

extension UINib {
    convenience init?(podNibName: String) {
        let podBundle = Bundle(for: DropDown.self)
//        self.init(nibName: "DropDownCell", bundle: podBundle)
        guard let url = podBundle.url(forResource: "MaterialUIAssets", withExtension: "bundle") else {
            return nil
        }
        self.init(nibName: "DropDownCell", bundle: Bundle(url: url))
        
    }
}

