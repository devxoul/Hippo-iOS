/*
 * UIButton+TouchAreaInsets.m
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013 Joyfl
 *
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 */

#import "UIButton+TouchAreaInsets.h"
#import <objc/runtime.h>

@implementation UIButton (TouchAreaInsets)

- (UIEdgeInsets)touchAreaInsets
{
	return [objc_getAssociatedObject( self, "_touchAreaInsets" ) UIEdgeInsetsValue];
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
	objc_setAssociatedObject( self, "_touchAreaInsets", [NSValue valueWithUIEdgeInsets:touchAreaInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
	CGRect bounds = self.bounds;
	bounds = CGRectMake( bounds.origin.x - touchAreaInsets.left,
						bounds.origin.y - touchAreaInsets.top,
						bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
						bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom );
	return CGRectContainsPoint( bounds, point );
}

@end
