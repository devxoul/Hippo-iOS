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
	
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
	self.activityIndicatorView.center = CGPointMake( UIScreenWidth / 2, UIScreenHeight / 2 );
	self.activityIndicatorView.hidesWhenStopped = YES;
	[self.view addSubview:self.activityIndicatorView];
	
	UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:L(@"PREV_EPISODE") style:UIBarButtonItemStylePlain target:nil action:nil];
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:L(@"NEXT_EPISODE") style:UIBarButtonItemStylePlain target:nil action:nil];
	
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
	self.barsHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)reload
{
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.episode.mobile_url]]];
}


#pragma mark -
#pragma mark Getter/Setter

- (void)setEpisode:(Episode *)episode
{
	_episode = episode;
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.activityIndicatorView stopAnimating];
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
	NSLog( @"velocity : %f", velocity );
	
	if( scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < scrollView.contentSize.height )
	{
		// 아래로 스크롤
		if( _lastOffsetY < scrollView.contentOffset.y )
		{
			self.barsHidden = YES;
		}
		
		// 위로 스크롤할 경우에는 순간속력이 특정 값을 초과할 경우에만
		else if( velocity < -2400 )
		{
			self.barsHidden = NO;
		}
	}
	
	_lastOffsetY = scrollView.contentOffset.y;
	_lastTime = [NSDate date];
}

@end
