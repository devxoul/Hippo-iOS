//
//  DishByMeAPILoader.h
//  Dish by.me
//
//  Created by 전수열 on 13. 2. 23..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AFNetworking.h"

@interface APILoader : NSObject
{
	AFHTTPClient *_client;
}

+ (id)sharedLoader;


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	  image:(UIImage *)image
	forName:(NSString *)name
   fileName:(NSString *)fileName
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	  image:(UIImage *)image
	forName:(NSString *)name
   fileName:(NSString *)fileName
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	 images:(NSArray *)images
   forNames:(NSArray *)names
  fileNames:(NSArray *)fileNames
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	 images:(NSArray *)images
   forNames:(NSArray *)names
  fileNames:(NSArray *)fileNames
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure;


#pragma mark -

+ (void)loadImageFromURLString:(NSString *)urlString
					   context:(id)context
					   success:(void (^)(UIImage *image, __strong id context))success;

+ (void)loadImageFromURL:(NSURL *)url
				 context:(id)context
				 success:(void (^)(UIImage *image, __strong id context))success;

@end
