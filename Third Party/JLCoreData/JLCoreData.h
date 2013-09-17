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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
+ (void)saveContext;

@end