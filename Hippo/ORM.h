//
//  ORM.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORM : NSManagedObject

+ (id)insert;
+ (NSArray *)all;
+ (NSArray *)filter:(NSString *)format, ...;

@end
