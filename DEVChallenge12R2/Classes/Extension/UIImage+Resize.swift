//
//  UIImage+Resize.swift
//  DEVChallenge12R2
//
//  Created by " " on 6/1/18.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit

extension UIImage {
    //image size to custom size
    func imageResize (sizeChange:CGSize)-> UIImage{
        let isAlpha = true
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(sizeChange, !isAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
