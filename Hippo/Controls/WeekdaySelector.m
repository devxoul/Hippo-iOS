//
//  WeekdaySelector.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WeekdaySelector.h"

@implementation WeekdaySelector

- (id)init
{
    self = [super initWithItems:@[@"전체", @"월", @"화", @"수", @"목", @"금", @"토", @"일", @"완결"]];
	self.selectedSegmentIndex = 0;
    return self;
}

@end
