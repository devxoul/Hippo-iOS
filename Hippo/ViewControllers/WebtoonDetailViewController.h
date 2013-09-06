//
//  WebtoonDetailViewController.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Webtoon.h"
#import "WebtoonDetailView.h"

@interface WebtoonDetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Webtoon *webtoon;
@property (nonatomic, strong) WebtoonDetailView *detailView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger bookmark;
@property (nonatomic, strong) NSMutableArray *episodes;

@end
