/*
 * UIImagePickerController+HTBlock.h
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, February 2013
 *
 * Copyright (C) 2013 GunWoo Choi
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

#import <UIKit/UIKit.h>

@interface UIImagePickerController (HTBlock)

@property (nonatomic, strong) void(^finishBlock)(UIImagePickerController* picker, NSDictionary* info);
@property (nonatomic, strong) void(^cancelBlock)(UIImagePickerController* picker);

@end
