/*
 * UIActionSheet+HTBlock.m
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

#import "UIActionSheet+HTBlock.h"
#import <objc/runtime.h>

@interface UIActionSheet () <UIActionSheetDelegate>

@property (nonatomic, strong) void(^dismissBlock)(UIActionSheet* actionSheet, NSUInteger buttonIndex);

@end

@implementation UIActionSheet (HTBlock)

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissBlock:(void(^)(UIActionSheet* actionSheet, NSUInteger buttonIndex))dismissBlock{
    self = [self initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    if (self) {
        for (NSString* otherTitle in otherButtonTitles) {
            [self addButtonWithTitle:otherTitle];
        }
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = self.numberOfButtons - 1;
        }
        self.dismissBlock = dismissBlock;
        self.delegate = self;
    }
    return self;
}

- (void (^)(UIActionSheet *, NSUInteger))dismissBlock{
    return objc_getAssociatedObject(self, "_dismissBlock");
}

- (void)setDismissBlock:(void (^)(UIActionSheet *, NSUInteger))dismissBlock{
    objc_setAssociatedObject(self, "_dismissBlock", dismissBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.dismissBlock) {
        self.dismissBlock(actionSheet, buttonIndex);
    }
}

@end
