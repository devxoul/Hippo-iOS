//
//  NSManagedObject+JLCoreData.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JLCoreData)

+ (id)insert;
+ (NSFetchRequest *)request;
+ (void)truncate;

@end
