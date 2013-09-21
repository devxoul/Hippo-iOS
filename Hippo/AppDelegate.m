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
#import "User.h"
#import "DejalActivityView.h"
#import "SSKeychain.h"

@implementation AppDelegate

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
	self.myWebtoonListViewController.title = L(@"MY_WEBTOONS");

	UINavigationController *myWebtoonListNavController = [[UINavigationController alloc] initWithRootViewController:self.myWebtoonListViewController];
	
	self.allWebtoonListViewController = [[WebtoonListViewController alloc] init];
	self.allWebtoonListViewController.type = HippoWebtoonListViewControllerTypeAllWebtoon;
	self.allWebtoonListViewController.title = L(@"SEARCH");
	
	UINavigationController *allWebtoonListNavController = [[UINavigationController alloc] initWithRootViewController:self.allWebtoonListViewController];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = @[myWebtoonListNavController, allWebtoonListNavController];
	self.window.rootViewController = tabBarController;
	
	tabBarController.selectedIndex = 1;
	tabBarController.selectedIndex = 0;
	
	[self login];
	
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

- (void)login
{
	self.activityView = [DejalBezelActivityView activityViewForView:self.window withLabel:[NSString stringWithFormat:@"%@...0%%", NSLocalizedString( @"LOADING", nil )]];
	
	NSDictionary *params = nil;
	NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:HippoSettingKeyEmail];
	if( email )
	{
		NSString *password = [SSKeychain passwordForService:HIPPO account:email];
		if( !password ) {
			NSLog( @"No password saved." );
			return;
		}
		
		params = @{@"email": email, @"password": password};
	}
	else
	{
		NSString *uuid = [SSKeychain passwordForService:HIPPO account:@"UUID"];
		if( !uuid ) {
			uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			[SSKeychain setPassword:uuid forService:HIPPO account:@"UUID"];
		}
		
		params = @{@"device_uuid": uuid, @"device_os": @"iOS"};
	}
	
	NSLog( @"Login params : %@", params );
	
	[[APILoader sharedLoader] api:@"login" method:@"POST" parameters:params success:^(id response) {
		NSLog( @"Login succeed : %@", response );
		
		User *user = [User insert];
		[user setValuesForKeysWithDictionary:response];
		[JLCoreData saveContext];
		
		[self compareRevision];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)compareRevision
{
	[[APILoader sharedLoader] api:@"/revision" method:@"GET" parameters:nil success:^(id response) {
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
			[self loadMyWebtoons];
		}
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadWebtoons
{
	[[APILoader sharedLoader] api:@"webtoons" method:@"GET" parameters:@{@"limit": @"100000"} upload:nil download:^(long long bytesLoaded, long long bytesTotal) {
		NSLog( @"%lld / %lld (%d%%)", bytesLoaded, bytesTotal, (NSInteger)(100.0 * bytesLoaded / bytesTotal) );
		self.activityView.activityLabel.text = [NSString stringWithFormat:@"%@...%d%%", NSLocalizedString( @"LOADING", nil ), (NSInteger)(100.0 * bytesLoaded / bytesTotal)];
		[self.activityView layoutSubviews];
	} success:^(id response) {
		[Webtoon truncate];
		NSArray *data = [response objectForKey:@"data"];
		for(NSDictionary *webtoonData in data)
		{
			Webtoon *webtoon = [[[Webtoon request] filter:@"id==%@", [webtoonData objectForKey:@"id"]] last];
			if( !webtoon ) {
				webtoon = [Webtoon insert];
			}
			[webtoon setValuesForKeysWithDictionary:webtoonData];
		}
		
		[JLCoreData saveContext];
		
		[self loadMyWebtoons];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadMyWebtoons
{
	for( Webtoon *webtoon in [[Webtoon request] all] )
	{
		webtoon.subscribed = [NSNumber numberWithBool:NO];
	}
	
	User *user = [[User request] first];
	NSString *api = [NSString stringWithFormat:@"/user/%@/webtoons", user.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:@{@"limit": @"100000"} success:^(id response) {
		NSArray *data = [response objectForKey:@"data"];
		NSLog( @"Loaded %d my webtoons.", data.count );
		for(NSDictionary *webtoonData in data)
		{
			Webtoon *webtoon = [[[Webtoon request] filter:@"id==%@", [webtoonData objectForKey:@"id"]] last];
			if( !webtoon ) {
				NSLog( @"WTF?? No webtoon!! : %@", webtoonData );
				webtoon = [Webtoon insert];
			}
			[webtoon setValuesForKeysWithDictionary:webtoonData];
		}
		
		[JLCoreData saveContext];
		
		[self.myWebtoonListViewController filterWebtoons];
		[self.allWebtoonListViewController filterWebtoons];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

@end
