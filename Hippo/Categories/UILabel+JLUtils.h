//
//  UILabel+JLUtils.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 11..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JLUtils)

@property (nonatomic, assign) CGFloat maxWidth;

- (id)initWithPosition:(CGPoint)position maxWidth:(CGFloat)maxWidth;

@end
