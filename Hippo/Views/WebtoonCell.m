//
//  WebtoonCell.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonCell.h"

@implementation WebtoonCell

- (id)init
{
	self = [super init];
	
	self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 41, 45 )];
	[self.contentView addSubview:self.thumbnailView];
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 0, 0, 0 )];
	[self.contentView addSubview:self.titleLabel];
	
	return self;
}

- (void)setWebtoon:(Webtoon *)webtoon
{
	_webtoon = webtoon;
	[self layoutContentView];
}

- (void)layoutContentView
{
	[self.thumbnailView setImageWithURL:[NSURL URLWithString:self.webtoon.thumbnailURL] placeholderImage:nil];
	self.titleLabel.text = self.webtoon.title;
	[self.titleLabel sizeToFit];
}

@end
