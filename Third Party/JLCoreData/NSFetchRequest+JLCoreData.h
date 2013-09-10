//
//  NSFetchRequest+JLCoreData.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (JLCoreData)

- (NSFetchRequest *)filter:(NSString *)format, ...;
- (NSFetchRequest *)orderBy:(NSString *)key;
- (id)first;
- (id)last;
- (NSArray *)all;

@end
