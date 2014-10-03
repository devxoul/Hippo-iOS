//
//  WebtoonCell.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class WebtoonCell: UITableViewCell {

    var thumbnailView = UIImageView()
    var titleLabel = UILabel()
    var countLabel = UILabel()
    var artistLabel = UILabel()
    var subscribeButton = SSBouncyButton()
    var portalIconView = UIImageView()
    var weekdayLabel = UILabel()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.thumbnailView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.countLabel)
        self.contentView.addSubview(self.artistLabel)
        self.contentView.addSubview(self.portalIconView)
        self.contentView.addSubview(self.weekdayLabel)
        self.contentView.addSubview(self.weekdayLabel)

        self.thumbnailView.snp_makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(60)
        }

        self.titleLabel.snp_makeConstraints { make in
            make.left.equalTo(65)
            make.top.equalTo(4)
            make.width.lessThanOrEqualTo(190)
        }

        self.countLabel.backgroundColor = UIColor.orangeColor()
        self.countLabel.textColor = UIColor.whiteColor()
        self.countLabel.font = UIFont.boldSystemFontOfSize(11)
        self.countLabel.layer.cornerRadius = 6
        self.countLabel.snp_makeConstraints { make in
            make.left.equalTo(self.titleLabel).with.offset(5)
            make.top.equalTo(self.titleLabel).with.offset(3)
        }

        self.artistLabel.font = UIFont.boldSystemFontOfSize(12)
        self.artistLabel.textColor = UIColor.grayColor()
        self.artistLabel.snp_makeConstraints { make in
            make.left.equalTo(65)
            make.top.equalTo(24)
            make.width.lessThanOrEqualTo(190)
        }

        self.weekdayLabel.font = UIFont.systemFontOfSize(11)
        self.weekdayLabel.textColor = UIColor.grayColor()
        self.weekdayLabel.snp_makeConstraints { make in
            make.left.equalTo(81)
            make.right.equalTo(41)
            make.width.lessThanOrEqualTo(170)
        }

        self.subscribeButton.titleLabel?.textAlignment = NSTextAlignment.Right
        self.accessoryView = self.subscribeButton
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
