/*
 * UIImagePickerController+HTBlock.m
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

#import "UIImagePickerController+HTBlock.h"
#import <objc/runtime.h>

@interface UIImagePickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation UIImagePickerController (HTBlock)

- (void)setFinishBlock:(void (^)(UIImagePickerController *, NSDictionary *))finishBlock{
    if (finishBlock != nil) {
        self.delegate = self;
    } else if(self.cancelBlock == nil) {
        self.delegate = nil;
    }
    objc_setAssociatedObject(self, "_finishBlock", finishBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIImagePickerController *, NSDictionary *))finishBlock{
    return objc_getAssociatedObject(self, "_finishBlock");
}

- (void)setCancelBlock:(void (^)(UIImagePickerController *))cancelBlock{
    if (cancelBlock != nil) {
        self.delegate = self;
    } else if (self.finishBlock == nil) {
        self.delegate = nil;
    }
    objc_setAssociatedObject(self, "_cancelBlock", cancelBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIImagePickerController *))cancelBlock{
    return objc_getAssociatedObject(self, "_cancelBlock");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (self.finishBlock) {
        self.finishBlock(picker, info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.cancelBlock) {
        self.cancelBlock(picker);
    }
}

@end
