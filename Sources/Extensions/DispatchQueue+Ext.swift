//
//  DispatchQueue+Ext.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func executeOnMainThread(_ closure: @escaping Closure) {
        if Thread.isMainThread {
            closure()
        } else {
            main.async(execute: closure)
        }
    }
}
