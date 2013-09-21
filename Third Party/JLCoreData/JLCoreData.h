//
//  JLCoreData.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+JLCoreData.h"
#import "NSFetchRequest+JLCoreData.h"

@interface JLCoreData : NSObject

+ (void)saveContext;

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end