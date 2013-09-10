//
//  AppDelegate.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebtoonListViewController.h"
#import <CoreData/CoreData.h>
#import "DejalActivityView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) WebtoonListViewController *myWebtoonListViewController;
@property (nonatomic, strong) WebtoonListViewController *allWebtoonListViewController;

@property (nonatomic, strong) DejalActivityView *activityView;

+ (AppDelegate *)appDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
