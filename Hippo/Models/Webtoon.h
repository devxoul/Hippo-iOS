//
//  Webtoon.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webtoon : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *portal;
@property (nonatomic, strong) NSString *portalID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, assign) BOOL mon;
@property (nonatomic, assign) BOOL tue;
@property (nonatomic, assign) BOOL wed;
@property (nonatomic, assign) BOOL thu;
@property (nonatomic, assign) BOOL fri;
@property (nonatomic, assign) BOOL sat;
@property (nonatomic, assign) BOOL sun;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL subscribed;
@property (nonatomic, assign) NSInteger newCount;

+ (Webtoon *)webtoonWithDictionary:(NSDictionary *)data;

@end
