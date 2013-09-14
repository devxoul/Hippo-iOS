//
//  WebtoonListViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonListViewController.h"
#import "Webtoon.h"
#import "WebtoonDetailViewController.h"
#import "DejalActivityView.h"

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
	[self.weekdaySelector addTarget:self action:@selector(filterWebtoons) forControlEvents:UIControlEventValueChanged];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + self.weekdaySelector.frame.size.height, UIScreenWidth, UIScreenHeight - 112 - self.weekdaySelector.frame.size.height)];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
	[self filterWebtoons];
}


#pragma mark -


- (void)filterWebtoons
{
	NSString *weekday = HippoWeekdays[self.weekdaySelector.selectedSegmentIndex];
	NSFetchRequest *request = nil;
	if( [weekday isEqualToString:@"all"] )
	{
		if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
			request = [[Webtoon request] filter:@"subscribed=1"];
		} else {
			request = [Webtoon request];
		}
	}
	else
	{
		if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
			request = [[Webtoon request] filter:@"subscribed=1&&%@=1", weekday];
		} else {
			request = [[Webtoon request] filter:@"%@=1", weekday];
		}
	}
	
	self.webtoons = [request orderBy:@"title"].all.mutableCopy;
	
	[self.tableView reloadData];
	[DejalBezelActivityView removeView];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.webtoons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"webtoonCellId";
	WebtoonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( !cell ) {
		cell = [[WebtoonCell alloc] initWithReuseIdentifier:cellId];
		cell.delegate = self;
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


#pragma mark -
#pragma mark WebtoonCellDelegate

- (void)webtoonCell:(WebtoonCell *)webtoonCell subscribeButtonDidTouchUpInside:(UIButton *)subscribeButton
{
	subscribeButton.showsActivityIndicatorView = YES;
	
	Webtoon *webtoon = webtoonCell.webtoon;
	if( !webtoon.subscribed.boolValue )
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", webtoon.id];
		[[APILoader sharedLoader] api:api method:@"POST" parameters:nil success:^(id response) {
			subscribeButton.showsActivityIndicatorView = NO;
			webtoon.subscribed = [NSNumber numberWithBool:YES];
			[webtoonCell layoutContentView];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.showsActivityIndicatorView = NO;
			webtoon.subscribed = [NSNumber numberWithBool:NO];
			[webtoonCell layoutContentView];
		}];
	}
	else
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", webtoon.id];
		[[APILoader sharedLoader] api:api method:@"DELETE" parameters:nil success:^(id response) {
			subscribeButton.showsActivityIndicatorView = NO;
			webtoon.subscribed = [NSNumber numberWithBool:NO];
			[webtoonCell layoutContentView];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.showsActivityIndicatorView = NO;
			webtoon.subscribed = [NSNumber numberWithBool:YES];
			[webtoonCell layoutContentView];
		}];
	}
}

@end
