//
//  UILabel+JLUtils.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 11..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "UILabel+JLUtils.h"
#import <objc/runtime.h>

@implementation UILabel (JLUtils)

- (id)initWithPosition:(CGPoint)position maxWidth:(CGFloat)maxWidth
{
	return self = [self initWithFrame:CGRectMake(position.x, position.y, self.maxWidth = maxWidth, 0)];
}

- (void)sizeToFit
{
	[super sizeToFit];
	if( self.maxWidth > 0 && self.frame.size.width > self.maxWidth )
	{
		CGRect frame = self.frame;
		frame.size.width = self.maxWidth;
		self.frame = frame;
	}
}

- (CGPoint)position
{
	return self.frame.origin;
}

- (void)setPosition:(CGPoint)position
{
	CGRect frame = self.frame;
	frame.origin = position;
	self.frame = frame;
}

- (CGFloat)maxWidth
{
	return [objc_getAssociatedObject( self, @"maxWidth" ) floatValue];
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
	objc_setAssociatedObject( self, @"maxWidth", [NSNumber numberWithFloat:maxWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end
