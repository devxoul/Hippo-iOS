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

@property (nonatomic, strong) Episode *episode;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
