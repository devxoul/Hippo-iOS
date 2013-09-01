/*
 * UIAlertView+HTBlock.m
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
#import "UIAlertView+HTBlock.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) void(^dismissBlock)(UIAlertView*, NSUInteger);

@end

@implementation UIAlertView (HTBlock)
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles dismissBlock:(void(^)(UIAlertView* alertView, NSUInteger buttonIndex))dismissBlock{
    self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        // Set titles
        for (NSString *otherTitle in otherButtonTitles) {
            [self addButtonWithTitle:otherTitle];
        }
        self.dismissBlock = dismissBlock;
        self.delegate = self;
    }
    return self;
}

- (void) alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSUInteger)buttonIndex{
    if (self.dismissBlock) {
        self.dismissBlock(alertView, buttonIndex);
    }
}

- (void)setDismissBlock:(void (^)(UIAlertView *, NSUInteger))dismissBlock{
    objc_setAssociatedObject(self, "_dismissBlock", dismissBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIAlertView *, NSUInteger))dismissBlock{
    return objc_getAssociatedObject(self, "_dismissBlock");
}

@end
