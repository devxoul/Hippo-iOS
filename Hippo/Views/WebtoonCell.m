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
	
	self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 55, 60 )];
	[self.contentView addSubview:self.thumbnailView];
	
	self.titleLabel = [[UILabel alloc] initWithPosition:CGPointMake( 65, 4 ) maxWidth:190];
	[self.contentView addSubview:self.titleLabel];
	
	self.artistLabel = [[UILabel alloc] initWithPosition:CGPointMake( 65, 24 ) maxWidth:190];
	self.artistLabel.font = [UIFont systemFontOfSize:12];
	self.artistLabel.textColor = [UIColor grayColor];
	[self.contentView addSubview:self.artistLabel];
	
	self.portalIconView = [[UIImageView alloc] initWithFrame:CGRectMake( 65, 41, 12, 12 )];
	[self.contentView addSubview:self.portalIconView];
	
	self.weekdayLabel = [[UILabel alloc] initWithPosition:CGPointMake( 81, 41 ) maxWidth:170];
	self.weekdayLabel.font = [UIFont systemFontOfSize:11];
	self.weekdayLabel.textColor = [UIColor grayColor];
	[self.contentView addSubview:self.weekdayLabel];
	
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
	
	if( [self.webtoon.artists count] )
	{
		NSMutableArray *artists = [NSMutableArray array];
		for( NSDictionary *artist in self.webtoon.artists ) {
			[artists addObject:[artist objectForKey:@"name"]];
		}
		self.artistLabel.text = [artists componentsJoinedByString:@", "];
		[self.artistLabel sizeToFit];
	}
	
	self.portalIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", self.webtoon.portal]];
	
	if( self.webtoon.finished.boolValue )
	{
		self.weekdayLabel.text = @"완결";
	}
	else
	{
		NSMutableArray *weekdays = [NSMutableArray array];
		for( NSInteger i = 1; i < 7; i++ )
		{
			NSString *weekday = HippoWeekdays[i];
			if( [[self.webtoon valueForKey:weekday] boolValue] ) {
				[weekdays addObject:NSLocalizedString( weekday.uppercaseString, nil )];
			}
		}
		NSLog( @"weekday : %@", [weekdays componentsJoinedByString:@", "] );
		self.weekdayLabel.text = [weekdays componentsJoinedByString:@", "];
	}
	[self.weekdayLabel sizeToFit];
	
	[self.subscribeButton setTitle:self.webtoon.subscribed.boolValue ? @"구독중" : @"구독하기" forState:UIControlStateNormal];
	[self.subscribeButton sizeToFit];
}

@end
