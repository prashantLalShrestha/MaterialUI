//
//  UIImage+Ext.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(podImageName: String) {
        let podBundle = Bundle(for: TextField.self)
        self.init(named: podImageName, in: podBundle, compatibleWith: nil)
//        guard let url = podBundle.url(forResource: "MaterialUIAssets", withExtension: "bundle") else {
//            return nil
//        }
//        self.init(named: podImageName, in: Bundle(url: url), compatibleWith: nil)
        
    }
    
    func scaled(to newSize: CGSize = CGSize(width: 32, height: 32)) -> UIImage? {
        let type = self
        let imageAspectRatio = type.size.width / type.size.height
        let canvasAspectRatio = newSize.width / newSize.height

        var resizeFactor: CGFloat

        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = newSize.width / type.size.width
        } else {
            resizeFactor = newSize.height / type.size.height
        }

        let scaledSize = CGSize(width: type.size.width * resizeFactor, height: type.size.height * resizeFactor)
        let origin = CGPoint(x: (newSize.width - scaledSize.width) / 2.0, y: (newSize.height - scaledSize.height) / 2.0)

        UIGraphicsBeginImageContextWithOptions(newSize, false, type.scale)
        type.draw(in: CGRect(origin: origin, size: scaledSize))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? type
        UIGraphicsEndImageContext()

        return scaledImage
    }
}

