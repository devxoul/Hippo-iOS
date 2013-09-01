//
//  UIView+JLAnimations.h
//  Dish by.me
//
//  Created by 전수열 on 13. 4. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JLAnimations)

- (void)shakeCount:(NSInteger)count radius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void(^)(void))completion;

@end
