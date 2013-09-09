//
//  AppDelegate.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AppDelegate.h"
#import "WebtoonListViewController.h"
#import "Webtoon.h"
#import "DejalActivityView.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (AppDelegate *)appDelegate
{
	return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	self.myWebtoonListViewController = [[WebtoonListViewController alloc] init];
	self.myWebtoonListViewController.type = HippoWebtoonListViewControllerTypeMyWebtoon;
	
	self.allWebtoonListViewController = [[WebtoonListViewController alloc] init];
	self.allWebtoonListViewController.type = HippoWebtoonListViewControllerTypeAllWebtoon;
	
	UINavigationController *myWebtoonListNavigationController = [[UINavigationController alloc] initWithRootViewController:self.myWebtoonListViewController];
	myWebtoonListNavigationController.title = @"내 웹툰";
	
	UINavigationController *allWebtoonListNavigationController = [[UINavigationController alloc] initWithRootViewController:self.allWebtoonListViewController];
	allWebtoonListNavigationController.title = @"검색";
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = @[myWebtoonListNavigationController, allWebtoonListNavigationController];
	self.window.rootViewController = tabBarController;
	
#warning 임시 코드
	[DejalBezelActivityView activityViewForView:self.window withLabel:@"로딩중..."];
	NSDictionary *params = @{@"email": @"ceo@joyfl.net",
							 @"password": @"8479b164f1c6bcdb8b92787b1e25feca1ac64cef"};
	[[APILoader sharedLoader] api:@"login" method:@"POST" parameters:params success:^(id response) {
		NSLog( @"Login succeed." );
		[self compareRevision];
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark APILoader

- (void)compareRevision
{
	[[APILoader sharedLoader] api:@"/revision" method:@"GET" parameters:nil success:^(id response) {
#warning 임시 코드
		NSNumber *localRevision = [[NSUserDefaults standardUserDefaults] objectForKey:HippoSettingKeyRevision];
		NSNumber *remoteRevision = [response objectForKey:@"revision"];
		NSLog( @"Webtoon Revision (local/remote) : %@ / %@", localRevision, remoteRevision );
		if( !localRevision || [localRevision integerValue] < [remoteRevision integerValue] )
		{
			[self loadWebtoons];
			[[NSUserDefaults standardUserDefaults] setObject:remoteRevision forKey:HippoSettingKeyRevision];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		else
		{
			[self.myWebtoonListViewController prepareWebtoons];
			[self.allWebtoonListViewController prepareWebtoons];
		}
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadWebtoons
{
	[[APILoader sharedLoader] api:@"webtoons" method:@"GET" parameters:@{@"limit": @"100000"} success:^(id response) {
		[Webtoon truncate];
		NSArray *data = [response objectForKey:@"data"];
		for(NSDictionary *webtoonData in data)
		{
			Webtoon *webtoon = [[Webtoon filter:@"id==%@", [webtoonData objectForKey:@"id"]] lastObject];
			if( !webtoon ) {
				webtoon = [Webtoon insert];
			}
			[webtoon safeSetValuesForKeysWithDictionary:webtoonData];
		}
		
		[[AppDelegate appDelegate] saveContext];
		
		[self.myWebtoonListViewController prepareWebtoons];
		[self.allWebtoonListViewController prepareWebtoons];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}


#pragma mark -
#pragma mark Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
	
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hippo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hippo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
