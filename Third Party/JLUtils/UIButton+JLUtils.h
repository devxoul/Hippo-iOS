//
//  UIButton+JLUtils.h
//  Dish by.me
//
//  Created by 전수열 on 13. 3. 22..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JLUtils)

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) BOOL titleLabelHidden;
@property (nonatomic, assign) BOOL imageViewHidden;
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;


- (BOOL)showsActivityIndicatorView;
- (void)setShowsActivityIndicatorView:(BOOL)showsActivityIndicatorView;

@end
