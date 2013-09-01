//
//  Utils.h
//  Dish by.me
//
//  Created by 전 수열 on 12. 9. 20..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIScreenWidth	[UIScreen mainScreen].bounds.size.width
#define UIScreenHeight	[UIScreen mainScreen].bounds.size.height

#define IPHONE5	(BOOL)( UIScreenHeight == 568.0 )

@interface Utils : NSObject

+ (id)parseJSONString:(NSString *)jsonString;
+ (id)parseJSONData:(NSData *)jsonData;
+ (NSString *)writeJSON:(id)object;

+ (NSString *)sha1:(NSString *)input;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateToLocalTimeZone:(NSDate *)date;
+ (NSDate *)dateToGlobalTimeZone:(NSDate *)date;
+ (NSString *)relativeDateString:(NSDate *)date withTime:(BOOL)withTime;

+ (UIImage *)cropImage:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage *)cropImageToSquare:(UIImage *)imageToCrop;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;

+ (BOOL)validateEmailWithString:(NSString *)email;

@end
