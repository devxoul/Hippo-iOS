//
//  UIButton+ActivityIndicator.m
//  Dish by.me
//
//  Created by 전수열 on 13. 3. 22..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "UIButton+ActivityIndicatorView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (ActivityIndicatorView)

- (UIActivityIndicatorView *)activityIndicatorView
{
	UIActivityIndicatorView *activityIndicatorView = objc_getAssociatedObject( self, "_activityIndicatorView" );
	if( !activityIndicatorView )
	{
		activityIndicatorView = [[UIActivityIndicatorView alloc] init];
		activityIndicatorView.center = CGPointMake( self.frame.size.width / 2, self.frame.size.height / 2 );
		[self addSubview:activityIndicatorView];
		objc_setAssociatedObject( self, "_activityIndicatorView", activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	return activityIndicatorView;
}

- (BOOL)showsActivityIndicatorView
{
	UIActivityIndicatorView *activityIndicatorView = self.activityIndicatorView;
	return activityIndicatorView.isAnimating;
}

- (void)setShowsActivityIndicatorView:(BOOL)showsActivityIndicatorView
{
	UIActivityIndicatorView *activityIndicatorView = self.activityIndicatorView;
	
	// Hide titleLabel by setting titleEdgeInsets to NSInterMax value.
	if( showsActivityIndicatorView )
	{
		self.titleLabelHidden = YES;
		self.imageViewHidden = YES;
		self.userInteractionEnabled = NO;
		[activityIndicatorView startAnimating];
	}
	else
	{
		self.titleLabelHidden = NO;
		self.imageViewHidden = NO;
		self.userInteractionEnabled = YES;
		[activityIndicatorView stopAnimating];
	}
}

- (BOOL)titleLabelHidden
{
	return self.titleEdgeInsets.top == -NSIntegerMax;
}

- (void)setTitleLabelHidden:(BOOL)titleLabelHidden
{
	if( titleLabelHidden )
	{
		objc_setAssociatedObject( self, "_originalTitleEdgeInsets", [NSValue valueWithUIEdgeInsets:self.titleEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
		self.titleEdgeInsets = UIEdgeInsetsMake( -NSIntegerMax, 0, 0, 0 );
	}
	else
	{
		self.titleEdgeInsets = [objc_getAssociatedObject( self, "_originalTitleEdgeInsets" ) UIEdgeInsetsValue];
	}
}

- (BOOL)imageViewHidden
{
	return self.imageEdgeInsets.top == -NSIntegerMax;
}

- (void)setImageViewHidden:(BOOL)imageViewHidden
{
	if( imageViewHidden )
	{
		objc_setAssociatedObject( self, "_originalImageEdgeInsets", [NSValue valueWithUIEdgeInsets:self.imageEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
		self.imageEdgeInsets = UIEdgeInsetsMake( -NSIntegerMax, 0, 0, 0 );
	}
	else
	{
		self.imageEdgeInsets = [objc_getAssociatedObject( self, "_originalImageEdgeInsets" ) UIEdgeInsetsValue];
	}
}

@end
