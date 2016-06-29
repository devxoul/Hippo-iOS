//
//  UIImage+GrayScale.swift
//  Hippo
//
//  Created by 전수열 on 10/9/14.
//  Updated by Arnaud Lamy on 29/06/2016 to support Swift 2
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

extension UIImage {
    func grayScaleImage() -> UIImage {
        let imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
        let colorSpace = CGColorSpaceCreateDeviceGray();

        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, .allZeros);
        CGContextDrawImage(context, imageRect, self.CGImage!);

        let imageRef = CGBitmapContextCreateImage(context);
        let newImage = UIImage(CGImage: imageRef!)
        return newImage
    }
}
