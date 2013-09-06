//
//  WebtoonListViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonListViewController.h"
#import "Webtoon.h"
#import "WebtoonCell.h"
#import "WebtoonDetailViewController.h"
#import "ORM.h"

@implementation WebtoonListViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
		self.navigationItem.title = @"내 웹툰";
	} else {
		self.navigationItem.title = @"검색";
	}
	
	self.weekdaySelector = [[WeekdaySelector alloc] init];
	self.weekdaySelector.frame = CGRectMake( 0, 64, UIScreenWidth, self.weekdaySelector.frame.size.height );
	[self.view addSubview:self.weekdaySelector];
	[self.weekdaySelector addTarget:self action:@selector(weekdayDidSelect) forControlEvents:UIControlEventValueChanged];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + self.weekdaySelector.frame.size.height, UIScreenWidth, UIScreenHeight - 112 - self.weekdaySelector.frame.size.height)];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
}

- (void)weekdayDidSelect
{
	
}


#pragma mark -

- (void)prepareWebtoons
{
	if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon )
	{
		self.webtoons = [[Webtoon filter:@"subscribed=1"] mutableCopy];
	}
	else
	{
		self.webtoons = [[Webtoon all] mutableCopy];
	}
	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.webtoons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"webtoonCellId";
	WebtoonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( !cell ) {
		cell = [[WebtoonCell alloc] initWithReuseIdentifier:cellId];
	}
	
	Webtoon *webtoon = [self.webtoons objectAtIndex:indexPath.row];
	cell.webtoon = webtoon;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	WebtoonDetailViewController *detailViewController = [[WebtoonDetailViewController alloc] init];
	detailViewController.webtoon = [self.webtoons objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
