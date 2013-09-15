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
	
	self.bookmarkView = [[UIImageView alloc] initWithFrame:CGRectMake( 275, 0, 10, 16 )];
	self.bookmarkView.image = [UIImage imageNamed:@"icon_bookmark.png"];
	[self.contentView addSubview:self.bookmarkView];
	
	return self;
}

- (void)setEpisode:(Episode *)episode bookmark:(NSInteger)bookmark
{
	_episode = episode;
	_bookmark = bookmark;
	[self layoutContentView];
}

- (void)layoutContentView
{
	__block UIImageView *thumbnailView = self.thumbnailView;
	__block Episode *episode = self.episode;
	[self.thumbnailView setImageWithURL:[NSURL URLWithString:self.episode.thumbnail_url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
		thumbnailView.image = episode.read.boolValue ? image.grayScaleImage : image;
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		
	}];
	
	self.titleLabel.text = self.episode.title;
	self.titleLabel.textColor = episode.read.boolValue ? [UIColor grayColor] : [UIColor blackColor];
	[self.titleLabel sizeToFit];
	
	self.bookmarkView.hidden = self.episode.id.integerValue != self.bookmark;
}

@end
