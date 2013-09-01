//
//  WebtoonCell.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webtoon.h"

@interface WebtoonCell : UITableViewCell

@property (nonatomic, strong) Webtoon *webtoon;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@end
