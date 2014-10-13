//
//  RealmHelper.h
//  Hippo
//
//  Created by 전수열 on 10/10/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealmHelper : NSObject

+ (BOOL)dropRealmIfNeeded;
+ (void)dropRealm;
+ (void)clearRevision;

@end
