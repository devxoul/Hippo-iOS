//
//  AFImageCache.m
//  Dish by.me
//
//  Created by 전수열 on 13. 3. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AFImageCache.h"

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

+ (AFImageCache *)sharedImageCache
{
	static AFImageCache *_af_imageCache = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_af_imageCache = [[AFImageCache alloc] init];
	});
	
	return _af_imageCache;
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request
{
	switch ([request cachePolicy]) {
		case NSURLRequestReloadIgnoringCacheData:
		case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
			return nil;
		default:
			break;
	}
	
	return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
		forRequest:(NSURLRequest *)request
{
	if (image && request) {
		[self setObject:image forKey:AFImageCacheKeyFromURLRequest(request)];
	}
}

@end