//
//  EpisodeCell.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 7..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeCell : UITableViewCell

@property (nonatomic, readonly) Episode *episode;
@property (nonatomic, readonly) NSInteger bookmark;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bookmarkView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setEpisode:(Episode *)episode bookmark:(NSInteger)bookmark;

@end
