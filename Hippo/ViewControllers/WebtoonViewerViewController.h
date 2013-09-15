//
//  WebtoonViewerViewController.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 15..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Episode.h"

@interface WebtoonViewerViewController : GAITrackedViewController <UIWebViewDelegate, UIScrollViewDelegate>
{
	CGFloat _lastOffsetY;
	NSDate *_lastTime;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) Episode *episode;
@property (nonatomic, strong) Episode *prevEpisode;
@property (nonatomic, strong) Episode *nextEpisode;
@property (nonatomic, assign) BOOL barsHidden;

@end
