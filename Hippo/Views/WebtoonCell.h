//
//  WebtoonCell.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webtoon.h"

@protocol WebtoonCellDelegate;

@interface WebtoonCell : UITableViewCell

@property (nonatomic, weak) id<WebtoonCellDelegate> delegate;
@property (nonatomic, strong) Webtoon *webtoon;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UIButton *subscribeButton;
@property (nonatomic, strong) UIImageView *portalIconView;
@property (nonatomic, strong) UILabel *weekdayLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)layoutContentView;

@end


@protocol WebtoonCellDelegate

- (void)webtoonCell:(WebtoonCell *)webtoonCell subscribeButtonDidTouchUpInside:(UIButton *)subscribeButton;

@end