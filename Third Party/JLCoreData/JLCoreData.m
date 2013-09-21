//
//  JLCoreData.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 17..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "JLCoreData.h"

@implementation JLCoreData

+ (id)sharedInstance
{
	static id instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[JLCoreData alloc] init];
	});
	return instance;
}

+ (void)saveContext
{
	NSMutableDictionary *managedObjectContexts = [JLCoreData managedObjectContexts];
	for( NSNumber *hash in managedObjectContexts )
	{
		NSManagedObjectContext *context = [managedObjectContexts objectForKey:hash];
		if( context.hasChanges ) {
			NSError *error = nil;
			[context save:&error];
			
			if( error )
			{
				if( [error isKindOfClass:[NSMergeConflict class]] ) {
					NSLog( @"Merge conflict. : %@", error.userInfo );
				} else {
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				}
			}
		}
	}
}

+ (NSMutableDictionary *)managedObjectContexts
{
	static NSMutableDictionary *managedObjectContexts = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		managedObjectContexts = [NSMutableDictionary dictionary];
	});
	return managedObjectContexts;
}

// "Create a separate managed object context for each thread and share a single persistent store coordinator."
// According to: https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Conceptual/CoreData/Articles/cdConcurrency.html
+ (NSManagedObjectContext *)managedObjectContext
{
	NSMutableDictionary *managedObjectContexts = [JLCoreData managedObjectContexts];
	
	NSNumber *hash = [NSNumber numberWithInteger:[NSThread currentThread].hash];
	NSManagedObjectContext *managedObjectContext = [managedObjectContexts objectForKey:hash];
	if( managedObjectContext ) {
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [JLCoreData persistentStoreCoordinator];
	if( coordinator ) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		managedObjectContext.persistentStoreCoordinator = coordinator;
		managedObjectContext.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSOverwriteMergePolicyType];
		[managedObjectContexts setObject:managedObjectContext forKey:hash];
	}
	
	return managedObjectContext;
}

+ (NSManagedObjectModel *)managedObjectModel
{
	static NSManagedObjectModel *managedObjectModel = nil;
    if( managedObjectModel ) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
	if( persistentStoreCoordinator ) {
		return persistentStoreCoordinator;
	}
	
	NSURL *storeURL = [[JLCoreData applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hippo.sqlite"];
	
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[JLCoreData managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible;
		 * The schema for the persistent store is incompatible with current managed object model.
		 Check the error message to determine what the actual problem was.
		 
		 
		 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
		 
		 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
		 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
		 
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
		 @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
		 
		 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end