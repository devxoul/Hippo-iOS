//
//  WebtoonListViewController.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekdaySelector.h"
#import "WebtoonCell.h"

@interface UINavigationBar (Hippo)
@end


@interface WebtoonListViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, WebtoonCellDelegate, UISearchBarDelegate>

typedef enum {
	HippoWebtoonListViewControllerTypeMyWebtoon,
	HippoWebtoonListViewControllerTypeAllWebtoon,
} HippoWebListViewControllerType;

@property (nonatomic, assign) HippoWebListViewControllerType type;
@property (nonatomic, strong) WeekdaySelector *weekdaySelector;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *webtoons;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

- (void)filterWebtoons;

@end
