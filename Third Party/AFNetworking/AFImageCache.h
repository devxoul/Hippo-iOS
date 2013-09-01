//
//  AFImageCache.h
//  Dish by.me
//
//  Created by 전수열 on 13. 3. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFImageCache : NSCache

+ (AFImageCache *)sharedImageCache;
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;

@end