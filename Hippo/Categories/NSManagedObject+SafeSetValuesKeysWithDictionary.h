//
//  NSManagedObject+SafeSetValuesKeysWithDictionary.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SafeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

@end
