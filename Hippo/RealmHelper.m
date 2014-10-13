//
//  RealmHelper.m
//  Hippo
//
//  Created by 전수열 on 10/10/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

#import <Realm/Realm.h>

#import "RealmHelper.h"

@implementation RealmHelper

+ (BOOL)dropRealmIfNeeded
{
    @try {
        [RLMRealm defaultRealm];
    }
    @catch (NSException *exception) {
        [self dropRealm];
        [self clearRevision];
        return YES;
    }
    return NO;
}

+ (void)dropRealm
{
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error: nil];
}

+ (void)clearRevision
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VendorRevisions"];
}

@end
