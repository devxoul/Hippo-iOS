//
//  UITableViewCell+Utils.m
//  Dish by.me
//
//  Created by 전수열 on 13. 5. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "UITableViewCell+Utils.h"

@implementation UITableViewCell (Utils)

- (NSIndexPath *)indexPath
{
	return [(UITableView *)self.superview indexPathForCell:self];
}

@end
