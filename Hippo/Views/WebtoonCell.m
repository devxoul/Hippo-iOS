//
//  WebtoonCell.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonCell.h"

@implementation WebtoonCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super init];
	
	self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 41, 45 )];
	[self.contentView addSubview:self.thumbnailView];
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 0, 0, 0 )];
	[self.contentView addSubview:self.titleLabel];
	
	self.subscribeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.accessoryView = self.subscribeButton;
	
	return self;
}

- (void)setWebtoon:(Webtoon *)webtoon
{
	_webtoon = webtoon;
	[self layoutContentView];
}

- (void)layoutContentView
{
	[self.thumbnailView setImageWithURL:[NSURL URLWithString:self.webtoon.thumbnail_url] placeholderImage:nil];
	
	self.titleLabel.text = self.webtoon.title;
	[self.titleLabel sizeToFit];
	
	[self.subscribeButton setTitle:self.webtoon.subscribed.boolValue ? @"구독중" : @"구독하기" forState:UIControlStateNormal];
	[self.subscribeButton sizeToFit];
}

@end
