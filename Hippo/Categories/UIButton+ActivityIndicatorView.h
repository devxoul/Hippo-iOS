//
//  UIButton+ActivityIndicator.h
//  Dish by.me
//
//  Created by 전수열 on 13. 3. 22..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ActivityIndicatorView)

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) BOOL titleLabelHidden;
@property (nonatomic, assign) BOOL imageViewHidden;


- (BOOL)showsActivityIndicatorView;
- (void)setShowsActivityIndicatorView:(BOOL)showsActivityIndicatorView;

@end
