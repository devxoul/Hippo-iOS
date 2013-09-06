//
//  WebtoonDetailView.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonDetailView.h"

@implementation WebtoonDetailView

- (id)init
{
	self = [super initWithFrame:CGRectMake( 0, 0, 320, 44 )];
	
	self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 41, 45 )];
	[self addSubview:self.thumbnailView];
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 0, 0, 0 )];
	[self addSubview:self.titleLabel];
	
	return self;
}

- (void)setWebtoon:(Webtoon *)webtoon
{
	_webtoon = webtoon;
	
	[self.thumbnailView setImageWithURL:[NSURL URLWithString:self.webtoon.thumbnail_url] placeholderImage:nil];
	
	self.titleLabel.text = self.webtoon.title;
	[self.titleLabel sizeToFit];
}

@end
