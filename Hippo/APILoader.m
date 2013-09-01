//
//  DishByMeAPILoader.m
//  Dish by.me
//
//  Created by 전수열 on 13. 2. 23..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "APILoader.h"
#import "Utils.h"
#import "AFImageCache.h"

@implementation APILoader

+ (id)sharedLoader
{
	static dispatch_once_t pred = 0;
    __strong static id __loader = nil;
    dispatch_once( &pred, ^{
        __loader = [[self alloc] init];
    });
    return __loader;
}

- (id)init
{
	self = [super init];
	
	_client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:API_ROOT_URL]];
	[_client setDefaultHeader:@"Accept" value:@"application/json; version=1.0;"];
	[_client setDefaultHeader:@"Content-Type" value:@"application/json"];
	[_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
	return self;
}


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	return [self api:api method:method parameters:parameters upload:nil download:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	NSURLRequest *request = [_client requestWithMethod:method path:[NSString stringWithFormat:@"/api/%@", api] parameters:parameters];
	
	return [self sendRequest:request upload:upload download:download success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSDictionary *errorInfo = [[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil] objectForKey:@"error"];
		NSInteger errorCode = [[errorInfo objectForKey:@"code"] integerValue];
		
		NSLog( @"URL(%@) : %@", method, operation.request.URL );
		NSLog( @"statusCode : %d", operation.response.statusCode );
		NSLog( @"errorCode : %d", errorCode );
		NSLog( @"message : %@", [errorInfo objectForKey:@"message"] );
		if( operation.response.statusCode == 500 )
			NSLog( @"response : %@", operation.responseString );
		if( failure )
			failure( operation.response.statusCode, errorCode, [errorInfo objectForKey:@"message"] );
	}];
}


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	  image:(UIImage *)image
	forName:(NSString *)name
   fileName:(NSString *)fileName
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	return [self api:api method:method image:image forName:name fileName:fileName parameters:parameters upload:nil download:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	  image:(UIImage *)image
	forName:(NSString *)name
   fileName:(NSString *)fileName
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	if( !image )
	{
		return [self api:api method:method parameters:parameters success:success failure:failure];
	}
	
	NSURLRequest *request = [_client multipartFormRequestWithMethod:method path:[NSString stringWithFormat:@"/api/%@", api] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFileData:UIImageJPEGRepresentation( image, 1 ) name:name fileName:fileName mimeType:@"image/jpeg"];
	}];
	
	return [self sendRequest:request upload:upload download:download success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSDictionary *errorInfo = [[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil] objectForKey:@"error"];
		NSInteger errorCode = [[errorInfo objectForKey:@"code"] integerValue];
		
		NSLog( @"URL(%@) : %@", method, operation.request.URL );
		failure( operation.response.statusCode, errorCode, [errorInfo objectForKey:@"message"] );
	}];
}


#pragma mark -

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	 images:(NSArray *)images
   forNames:(NSArray *)names
  fileNames:(NSArray *)fileNames
 parameters:(NSDictionary *)parameters
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	return [self api:api method:method images:images forNames:names fileNames:fileNames parameters:parameters upload:nil download:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)api:(NSString *)api
	 method:(NSString *)method
	 images:(NSArray *)images
   forNames:(NSArray *)names
  fileNames:(NSArray *)fileNames
 parameters:(NSDictionary *)parameters
	 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
	success:(void (^)(id response))success
	failure:(void (^)(NSInteger statusCode, NSInteger errorCode, NSString *message))failure
{
	if( !images || images.count == 0 )
	{
		return [self api:api method:method parameters:parameters success:success failure:failure];
	}
	
	if( images.count != names.count || names.count != fileNames.count )
	{
		NSLog( @"Must be image.count == names.count == fileNames.count" );
		return nil;
	}
	
	NSURLRequest *request = [_client multipartFormRequestWithMethod:method path:[NSString stringWithFormat:@"/api/%@", api] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		
		for( NSInteger i = 0; i < images.count; i++ )
		{
			UIImage *image = [images objectAtIndex:i];
			NSString *name = [names objectAtIndex:i];
			NSString *fileName = [fileNames objectAtIndex:i];
			[formData appendPartWithFileData:UIImageJPEGRepresentation( image, 1 ) name:name fileName:fileName mimeType:@"image/jpeg"];
		}
	}];
	
	return [self sendRequest:request upload:upload download:download success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSDictionary *errorInfo = operation.responseData ? [[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil] objectForKey:@"error"] : nil;
		NSInteger errorCode = [[errorInfo objectForKey:@"code"] integerValue];
		
		NSLog( @"URL(%@) : %@", method, operation.request.URL );
		failure( operation.response.statusCode, errorCode, [errorInfo objectForKey:@"message"] );
		if( operation.response.statusCode >= 500 )
		{
			NSLog( @"response : %@", operation.responseString );
		}
	}];
}


#pragma mark -

- (AFHTTPRequestOperation *)sendRequest:(NSURLRequest *)request
			 upload:(void (^)(long long bytesLoaded, long long bytesTotal))upload
		   download:(void (^)(long long bytesLoaded, long long bytesTotal))download
			success:(void (^)(id response))success
			failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if( success )
			success( responseObject );
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if( error )
		{
			// 요청 시간 초과
			if( error.code == -1001 )
			{
				[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", nil ) message:NSLocalizedString( @"MESSAGE_REQUEST_TIMEOUT", nil ) cancelButtonTitle:NSLocalizedString( @"RETRY", nil ) otherButtonTitles:nil dismissBlock:^(UIAlertView *alertView, NSUInteger buttonIndex) {
					
					[self sendRequest:request upload:upload download:download success:success failure:failure];
					
				}] show];
				return;
			}
			
			// 인터넷 연결 오프라인
			else if( error.code == -1009 )
			{
				[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", nil ) message:NSLocalizedString( @"MESSAGE_INTERNET_OFFLINE", nil ) cancelButtonTitle:NSLocalizedString( @"RETRY", nil ) otherButtonTitles:nil dismissBlock:^(UIAlertView *alertView, NSUInteger buttonIndex) {
					
					dispatch_async(dispatch_get_main_queue(), ^{
						[self sendRequest:request upload:upload download:download success:success failure:failure];
					});
					
				}] show];
				return;
			}
			else
			{
				NSLog( @"Error : %@", error );
				failure( operation, error );
			}
		}
		
	}];
	
	if( upload )
	{
		[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
			upload( totalBytesWritten, totalBytesExpectedToWrite );
		}];
	}
	
	if( download )
	{
		[operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
			download( totalBytesRead, totalBytesExpectedToRead );
		}];
	}
	
	[_client enqueueHTTPRequestOperation:operation];
	return operation;
}


#pragma mark -

+ (void)loadImageFromURLString:(NSString *)urlString
					   context:(id)context
					   success:(void (^)(UIImage *image, __strong id context))success
{
	[APILoader loadImageFromURL:[NSURL URLWithString:urlString] context:context success:success];
}

+ (void)loadImageFromURL:(NSURL *)url
				 context:(id)context
				 success:(void (^)(UIImage *image, __strong id context))success
{
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	UIImage *cachedImage = [[AFImageCache sharedImageCache] cachedImageForRequest:request];
	if( cachedImage )
	{
		if( success )
			success( cachedImage, context );
		return;
	}
	
	AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
		[[AFImageCache sharedImageCache] cacheImage:image forRequest:request];
		if( success )
			success( image, context );
	}];
	[operation start];
}

@end
