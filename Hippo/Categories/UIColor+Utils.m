/*
 * UIColor+Utils.m
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

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithHex:(NSInteger)color alpha:(CGFloat)alpha
{
	NSInteger red = ( color >> 16 ) & 0xFF;
	NSInteger green = ( color >> 8 ) & 0xFF;
	NSInteger blue = color & 0xFF;
	return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
