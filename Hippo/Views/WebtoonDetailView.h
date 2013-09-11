//
//  WebtoonDetailView.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webtoon.h"

@interface WebtoonDetailView : UIView

@property (nonatomic, strong) Webtoon *webtoon;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UIButton *subscribeButton;
@property (nonatomic, strong) UIImageView *portalIconView;
@property (nonatomic, strong) UILabel *weekdayLabel;

@end
