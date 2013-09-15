//
//  UIImage+JLUtils.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 15..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "UIImage+JLUtils.h"

@implementation UIImage (JLUtils)

- (UIImage *)grayScaleImage
{
    CGFloat actualWidth = self.size.width;
    CGFloat actualHeight = self.size.height;
	
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, self.CGImage);
	
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
	
    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, self.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
	
    return grayScaleImage;
}

@end
