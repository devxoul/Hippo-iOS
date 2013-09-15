//
//  WebtoonViewerViewController.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 15..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Webtoon.h"
#import "Episode.h"

@interface WebtoonViewerViewController : GAITrackedViewController <UIWebViewDelegate, UIScrollViewDelegate>
{
	CGFloat _lastOffsetY;
	NSDate *_lastTime;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readonly) Webtoon *webtoon;
@property (nonatomic, readonly) Episode *episode;
@property (nonatomic, readonly) Episode *prevEpisode;
@property (nonatomic, readonly) Episode *nextEpisode;
@property (nonatomic, readonly) NSArray *episodes;
@property (nonatomic, assign) BOOL barsHidden;

- (void)setEpisodes:(NSArray *)episodes currentEpisodeIndex:(NSInteger)index webtoon:(Webtoon *)webtoon;

@end
