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
			[[AppDelegate appDelegate] saveContext];
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
			[[AppDelegate appDelegate] saveContext];
			[self updateNaviagtionItem];
		}];
	}
}


#pragma mark -
#pragma mark

- (void)compareRevision
{
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/revision", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		NSNumber *revision = [response objectForKey:@"revision"];
		NSLog( @"Episode Revision (local/remote) : %@ / %@", self.webtoon.revision, revision );
		if( [self.webtoon.revision integerValue] < [revision integerValue] )
		{
			[self loadEpisodes];
			self.webtoon.revision = revision;
			[[AppDelegate appDelegate] saveContext];
		}
		else
		{
			self.episodes = [[[[[Episode request] filter:@"webtoon_id==%@", self.webtoon.id] orderBy:@"no desc"] all] mutableCopy];
			[self loadBookmark];
		}
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadEpisodes
{
	self.activityView = [DejalBezelActivityView activityViewForView:self.tabBarController.navigationController.view withLabel:[NSString stringWithFormat:@"%@...0%%", NSLocalizedString( @"LOADING", nil )]];
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/episodes?limit=9999", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil upload:nil download:^(long long bytesLoaded, long long bytesTotal) {
		self.activityView.activityLabel.text = [NSString stringWithFormat:@"%@...%d%%", NSLocalizedString( @"LOADING", nil ), (NSInteger)(100.0 * bytesLoaded / bytesTotal)];
		[self.activityView layoutSubviews];
		
	} success:^(id response) {
		self.bookmark = [[response objectForKeyNotNull:@"bookmark"] integerValue];
		NSArray *data = [response objectForKey:@"data"];
		for( NSDictionary *episodeData in data )
		{
			Episode *episode = [[[Episode request] filter:@"id==%@", [episodeData objectForKey:@"id"]] last];
			if( !episode ) {
				episode = [Episode insert];
			}
			[episode setValuesForKeysWithDictionary:episodeData];
			[self.episodes addObject:episode];
		}
		[[AppDelegate appDelegate] saveContext];
		
		[self loadBookmark];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		[DejalBezelActivityView removeView];
		showErrorAlert();
	}];
}

- (void)loadBookmark
{
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/bookmark", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		self.bookmark = [[response objectForKey:@"bookmark"] integerValue];
		
		[DejalBezelActivityView removeView];
		[self.tableView reloadData];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		
	}];
}

- (void)readEpisode:(Episode *)episode
{
	episode.read = @YES;
	self.bookmark = episode.id.integerValue;
	
	[[AppDelegate appDelegate] saveContext];
	[self.tableView reloadData];
	
	NSString *api = [NSString stringWithFormat:@"/episode/%@/read", episode.id];
	[[APILoader sharedLoader] api:api method:@"POST" parameters:nil success:^(id response) {
		NSLog( @"Read success" );
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		episode.read = @NO;
		
		NSLog( @"Read failure" );
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
	
	[cell setEpisode:[self.episodes objectAtIndex:indexPath.row] bookmark:self.bookmark];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	Episode *episode = [self.episodes objectAtIndex:indexPath.row];
	
	[self readEpisode:episode];
	
	WebtoonViewerViewController *viewer = [[WebtoonViewerViewController alloc] init];
	viewer.episode = episode;
	if( indexPath.row > 0 ) {
		viewer.prevEpisode = [self.episodes objectAtIndex:indexPath.row - 1];
	}
	if( indexPath.row < self.episodes.count - 1 ) {
		viewer.nextEpisode = [self.episodes objectAtIndex:indexPath.row + 1];
	}
	[self.navigationController pushViewController:viewer animated:YES];
}

@end
