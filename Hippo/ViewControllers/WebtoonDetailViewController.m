//
//  WebtoonDetailViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonDetailViewController.h"
#import "Episode.h"
#import "EpisodeCell.h"
#import "WebtoonViewerViewController.h"

@implementation WebtoonDetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.title = self.webtoon.title;
	
	UIBarButtonItem *subscribeButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(subscribeButtonDidTouchUpInside)];
	self.navigationItem.rightBarButtonItem = subscribeButton;
	[self updateNaviagtionItem];
	
	self.detailView = [[WebtoonDetailView alloc] init];
	self.detailView.webtoon = self.webtoon;
	self.detailView.frame = CGRectMake( 0, 64, UIScreenWidth, self.detailView.frame.size.height );
	[self.view addSubview:self.detailView];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + self.detailView.frame.size.height, UIScreenWidth, UIScreenHeight - self.detailView.frame.size.height - 64)];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
	
	self.episodes = [NSMutableArray array];
	
	[self compareRevision];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
	
	UIView *weekdaySelector = nil;
	for( weekdaySelector in self.navigationController.navigationBar.subviews )
	{
		if( [weekdaySelector isKindOfClass:WeekdaySelector.class] ) {
			break;
		}
	}
	
	[UIView animateWithDuration:0.25 animations:^{
		weekdaySelector.alpha = 0;
		[[[[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] setFrame:CGRectMake( 0, 0, 320, 64 )];
		[[[[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews] objectAtIndex:1] setPosition:CGPointMake( 0, 64 )];
	}];
}

- (void)updateNaviagtionItem
{
	UIBarButtonItem *subscribeButton = self.navigationItem.rightBarButtonItem;
	subscribeButton.title = self.webtoon.subscribed.boolValue ? L( @"UNSUBSCRIBE" ) : L( @"SUBSCRIBE" );
}

- (void)subscribeButtonDidTouchUpInside
{
	UIBarButtonItem *subscribeButton = self.navigationItem.rightBarButtonItem;
	subscribeButton.enabled = NO;
	
	if( !self.webtoon.subscribed.boolValue )
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", self.webtoon.id];
		[[APILoader sharedLoader] api:api method:@"POST" parameters:nil success:^(id response) {
			subscribeButton.enabled = YES;
			self.webtoon.subscribed = [NSNumber numberWithBool:YES];
			[JLCoreData saveContext];
			[self updateNaviagtionItem];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.enabled = YES;
			self.webtoon.subscribed = [NSNumber numberWithBool:NO];
			[self updateNaviagtionItem];
		}];
	}
	else
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", self.webtoon.id];
		[[APILoader sharedLoader] api:api method:@"DELETE" parameters:nil success:^(id response) {
			subscribeButton.enabled = YES;
			self.webtoon.subscribed = [NSNumber numberWithBool:NO];
			[self updateNaviagtionItem];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.enabled = YES;
			self.webtoon.subscribed = [NSNumber numberWithBool:YES];
			[JLCoreData saveContext];;
			[self updateNaviagtionItem];
		}];
	}
}


#pragma mark -
#pragma mark

- (void)compareRevision
{
	NSLog( @"Comparing webtoon revisions..." );
	
	self.activityView = [DejalBezelActivityView activityViewForView:self.navigationController.view withLabel:[NSString stringWithFormat:@"%@...0%%", NSLocalizedString( @"LOADING", nil )]];
	
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/revision", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		NSNumber *revision = [response objectForKey:@"revision"];
		NSLog( @"Episode Revision (local/remote) : %@ / %@", self.webtoon.revision, revision );
		if( [self.webtoon.revision integerValue] < [revision integerValue] )
		{
			self.webtoon.revision = revision;
			[JLCoreData saveContext];
			[self loadEpisodes];
		}
		else
		{
			NSLog( @"Loading episodes from local db..." );
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
				self.episodes = [[[[[Episode request] filter:@"webtoon_id==%@", self.webtoon.id] orderBy:@"no desc"] all] mutableCopy];
				NSLog( @"Loaded %d episodes from local db.", self.episodes.count );
				[self loadBookmark];
			});
		}
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadEpisodes
{
	NSLog( @"Loading episodes from server..." );
	
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/episodes?limit=9999", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil upload:nil download:^(long long bytesLoaded, long long bytesTotal) {
		self.activityView.activityLabel.text = [NSString stringWithFormat:@"%@...%d%%", NSLocalizedString( @"LOADING", nil ), (NSInteger)(100.0 * bytesLoaded / bytesTotal)];
		[self.activityView layoutSubviews];
		
	} success:^(id response) {
		self.webtoon.bookmark = [response objectForKeyNotNull:@"bookmark"];
		
		NSArray *data = [response objectForKey:@"data"];
		NSLog( @"Loaded %d episodes. (bookmark : %@)", data.count, self.webtoon.bookmark );
		for( NSDictionary *episodeData in data )
		{
			Episode *episode = [[[Episode request] filter:@"id==%@", [episodeData objectForKey:@"id"]] last];
			if( !episode ) {
				episode = [Episode insert];
			}
			[episode setValuesForKeysWithDictionary:episodeData];
			[self.episodes addObject:episode];
		}
		
		[JLCoreData saveContext];
		
		[DejalBezelActivityView removeView];
		[self.tableView reloadData];
		[self scrollToBookmark];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		[DejalBezelActivityView removeView];
		showErrorAlert();
	}];
}

- (void)loadBookmark
{
	NSLog( @"Loading bookmark..." );
	
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/bookmark", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		self.webtoon.bookmark = [response objectForKey:@"bookmark"];
		NSLog( @"Loaded bookmark : %@", self.webtoon.bookmark );
		
		[DejalBezelActivityView removeView];
		[self.tableView reloadData];
		[self scrollToBookmark];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		
	}];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.episodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"cellId";
	EpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( !cell ) {
		cell = [[EpisodeCell alloc] initWithReuseIdentifier:cellId];
	}
	
	[cell setEpisode:[self.episodes objectAtIndex:indexPath.row] bookmark:self.webtoon.bookmark.integerValue];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	WebtoonViewerViewController *viewer = [[WebtoonViewerViewController alloc] init];
	[viewer setEpisodes:self.episodes currentEpisodeIndex:indexPath.row webtoon:self.webtoon];
	
	self.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:viewer animated:YES];
	self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollToBookmark
{
	for( NSInteger i = 0; i < self.episodes.count; i++ )
	{
		Episode *episode = [self.episodes objectAtIndex:i];
		if( episode.id.integerValue == self.webtoon.bookmark.integerValue )
		{
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
			break;
		}
	}
}

@end
