//
//  EpisodeCell.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 7..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "EpisodeCell.h"

@implementation EpisodeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super init];
	
	self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 71, 42 )];
	[self.contentView addSubview:self.thumbnailView];
	
	self.titleLabel = [[UILabel alloc] initWithPosition:CGPointMake( 80, 13 ) maxWidth:230];
	self.titleLabel.font = [UIFont systemFontOfSize:13];
	[self.contentView addSubview:self.titleLabel];
	
	return self;
}

- (void)setEpisode:(Episode *)episode
{
	_episode = episode;
	[self layoutContentView];
}

- (void)layoutContentView
{
	[self.thumbnailView setImageWithURL:[NSURL URLWithString:self.episode.thumbnail_url] placeholderImage:nil];
	
	self.titleLabel.text = self.episode.title;
	[self.titleLabel sizeToFit];
}

@end
