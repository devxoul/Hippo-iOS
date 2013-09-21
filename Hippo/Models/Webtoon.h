//
//  Webtoon.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 11..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Webtoon : NSManagedObject

@property (nonatomic, retain) NSNumber * bookmark;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * fri;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * mon;
@property (nonatomic, retain) NSNumber * new_count;
@property (nonatomic, retain) NSString * portal;
@property (nonatomic, retain) NSString * portal_id;
@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSNumber * sat;
@property (nonatomic, retain) NSNumber * subscribed;
@property (nonatomic, retain) NSNumber * sun;
@property (nonatomic, retain) NSNumber * thu;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * tue;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * wed;
@property (nonatomic, retain) id artists;

@end
