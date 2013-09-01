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

@implementation WebtoonListViewController


- (void)viewDidLoad
{
	if( self.type == HippoWebListViewControllerTypeMyWebtoon ) {
		self.navigationItem.title = @"내 웹툰";
	} else {
		self.navigationItem.title = @"검색";
	}
	
	self.weekdaySelector = [[WeekdaySelector alloc] init];
	self.weekdaySelector.frame = CGRectMake( 0, 64, UIScreenWidth, self.weekdaySelector.frame.size.height );
	[self.view addSubview:self.weekdaySelector];
	[self.weekdaySelector addTarget:self action:@selector(weekdayDidSelect) forControlEvents:UIControlEventValueChanged];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + self.weekdaySelector.frame.size.height, UIScreenWidth, UIScreenHeight - 64 - self.weekdaySelector.frame.size.height)];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
	
	self.webtoons = [NSMutableArray array];
	
	[self loadWebtoons];
}

- (void)weekdayDidSelect
{
	
}


#pragma mark -
#pragma mark APILoader

- (void)loadWebtoons
{
	[[APILoader sharedLoader] api:@"webtoons" method:@"GET" parameters:nil success:^(id response) {
		NSArray *data = [response objectForKey:@"data"];
		for(NSDictionary *webtoonData in data)
		{
			Webtoon *webtoon = [Webtoon webtoonWithDictionary:webtoonData];
			[self.webtoons addObject:webtoon];
		}
		
		[self.tableView reloadData];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
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
	if( !cell )
		cell = [[WebtoonCell alloc] init];
	
	Webtoon *webtoon = [self.webtoons objectAtIndex:indexPath.row];
	cell.webtoon = webtoon;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
