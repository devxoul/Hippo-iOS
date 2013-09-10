//
//  Episode.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ORM.h"


@interface Episode : ORM

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * no;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * webtoon_id;

@end
