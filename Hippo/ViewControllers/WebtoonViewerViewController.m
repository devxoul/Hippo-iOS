//
//  WebtoonViewerViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 15..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonViewerViewController.h"

@implementation WebtoonViewerViewController

- (void)viewDidLoad
{
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake( 0, -64, UIScreenWidth, UIScreenHeight + 108 )];
	self.webView.delegate = self;
	self.webView.scrollView.delegate = self;
	self.webView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.webView];
	
	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(webViewDidSwipe)];
	swipeRecognizer.delegate = self;
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewDidTap)];
	tapRecognizer.delegate = self;
	[self.webView addGestureRecognizer:swipeRecognizer];
	[self.webView addGestureRecognizer:tapRecognizer];
	
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView.center = CGPointMake( UIScreenWidth / 2, UIScreenHeight / 2 );
	self.activityIndicatorView.hidesWhenStopped = YES;
	[self.view addSubview:self.activityIndicatorView];
	
	UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:L(@"PREV_EPISODE") style:UIBarButtonItemStylePlain target:self action:@selector(loadPrevEpisode)];
	prevButton.enabled = !!_prevEpisode;
	
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:L(@"NEXT_EPISODE") style:UIBarButtonItemStylePlain target:self action:@selector(loadNextEpisode)];
	nextButton.enabled = !!_nextEpisode;
	
	self.toolbarItems = @[reloadButton,
						  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						  prevButton,
						  nextButton
						  ];
	
	[self reload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	self.barsHidden = NO;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)reload
{
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.episode.mobile_url]]];
}

- (void)loadPrevEpisode
{
	NSInteger currentIndex = [self.episodes indexOfObject:self.episode];
	[self setEpisodes:self.episodes currentEpisodeIndex:currentIndex + 1 webtoon:self.webtoon];
	[self reload];
}

- (void)loadNextEpisode
{
	NSInteger currentIndex = [self.episodes indexOfObject:self.episode];
	[self setEpisodes:self.episodes currentEpisodeIndex:currentIndex - 1 webtoon:self.webtoon];
	[self reload];
}

- (void)read
{
	self.episode.read = @YES;
	self.webtoon.bookmark = self.episode.id;
	
	[JLCoreData saveContext];
	
	NSString *api = [NSString stringWithFormat:@"/episode/%@/read", self.episode.id];
	[[APILoader sharedLoader] api:api method:@"POST" parameters:nil success:^(id response) {
		NSLog( @"Read success" );
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		self.episode.read = @NO;
		
		NSLog( @"Read failure" );
	}];

	NSInteger newCount = 0;
	for( Episode *episode in self.episodes )
	{
		if( episode.read.boolValue ) {
			break;
		}
		newCount ++;
	}
	
	NSLog( @"newCount : %d", newCount );
	
	self.webtoon.new_count = [NSNumber numberWithInteger:newCount];
}


#pragma mark -
#pragma mark Getter/Setter

- (void)setEpisodes:(NSArray *)episodes currentEpisodeIndex:(NSInteger)index webtoon:(Webtoon *)webtoon
{
	_webtoon = webtoon;
	_episodes = episodes;
	_episode = [episodes objectAtIndex:index];
	
	_prevEpisode = _nextEpisode = nil;
	if( index < episodes.count - 1 ) {
		_prevEpisode = [self.episodes objectAtIndex:index + 1];
	}
	if( index > 0 ) {
		_nextEpisode = [self.episodes objectAtIndex:index - 1];
	}
	
	[[self.toolbarItems objectAtIndex:2] setEnabled:!!_prevEpisode];
	[[self.toolbarItems objectAtIndex:3] setEnabled:!!_nextEpisode];
}

- (void)setBarsHidden:(BOOL)hidden
{
	if( _barsHidden == hidden ) return;
	_barsHidden = hidden;
	
	CGFloat navigationBarY, toolbarY;
	
	if( hidden ) {
		navigationBarY = -44;
		toolbarY = UIScreenHeight;
	} else {
		navigationBarY = 20;
		toolbarY = UIScreenHeight - 44;
	}
	
	[UIView animateWithDuration:0.25 animations:^{
		self.navigationController.navigationBar.frame = CGRectMake( 0, navigationBarY, UIScreenWidth, 44 );
		self.navigationController.toolbar.frame = CGRectMake( 0, toolbarY, UIScreenWidth, 44 );
	}];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	[self.activityIndicatorView startAnimating];
	self.barsHidden = NO;
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.activityIndicatorView stopAnimating];
	
	double delayInSeconds = 1.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		self.barsHidden = YES;
	});
	
	[self read];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSTimeInterval timedelta = -1 * [_lastTime timeIntervalSinceNow];
	CGFloat velocity = (scrollView.contentOffset.y - _lastOffsetY) / timedelta;
//	NSLog( @"velocity : %f", velocity );
	
	if( scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.contentSize.height )
	{
		// 아래로 스크롤
		if( _lastOffsetY < scrollView.contentOffset.y )
		{
			self.barsHidden = YES;
		}
		
		// 위로 스크롤할 경우에는 순간속력이 특정 값을 초과할 경우에만 || 맨 아래로 스크롤했을 경우
		else if( velocity < -1500 || scrollView.contentOffset.y + scrollView.bounds.size.height - 44 == scrollView.contentSize.height )
		{
			self.barsHidden = NO;
		}
	}
	
	_lastOffsetY = scrollView.contentOffset.y;
	_lastTime = [NSDate date];
}


#pragma mark -
#pragma mark UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)webViewDidSwipe
{
//	NSLog( @"Swipe" );
//	NSLog( @"self.webView.scrollView.contentSize.height : %f", self.webView.scrollView.contentSize.height );
//	NSLog( @"self.webView.bounds.size.height : %f", self.webView.bounds.size.height );
//	NSLog( @"self.webView.scrollView.bounds.size.height : %f", self.webView.scrollView.bounds.size.height );
	
	// 스마트툰
	if( self.webView.scrollView.contentSize.height - 10 == self.webView.bounds.size.height )
	{
		self.barsHidden = NO;
	}
}

- (void)webViewDidTap
{
	self.barsHidden = YES;
}

@end
