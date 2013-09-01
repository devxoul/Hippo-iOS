//
//  UIResponder+Dim.h
//  Dish by.me
//
//  Created by 전수열 on 13. 2. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Dim)

- (void)dim;
- (void)dimAnimated:(BOOL)animated;
- (void)dimWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
- (void)dimWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion;

- (void)undim;
- (void)undimAnimated:(BOOL)animated;
- (void)undimWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
- (void)undimWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion;

- (BOOL)isDimmed;

@end
