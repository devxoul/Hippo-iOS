//
//  NSDictionary+Utils.m
//  Dish by.me
//
//  Created by 전수열 on 13. 4. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (id)objectForKeyNotNull:(id)key
{
	id object = [self objectForKey:key];
	if( [object isEqual:[NSNull null]] )
		return nil;
	return object;
}

@end
