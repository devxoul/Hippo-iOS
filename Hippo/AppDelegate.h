//
//  AppDelegate.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebtoonListViewController.h"
#import "DejalActivityView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) WebtoonListViewController *myWebtoonListViewController;
@property (nonatomic, strong) WebtoonListViewController *allWebtoonListViewController;

@property (nonatomic, strong) DejalActivityView *activityView;

+ (AppDelegate *)appDelegate;

@end
