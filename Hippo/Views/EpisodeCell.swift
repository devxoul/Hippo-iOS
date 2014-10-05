//
//  EpisodeCell.swift
//  Hippo
//
//  Created by 전수열 on 10/6/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class EpisodeCell: UITableViewCell {

    private var _episode: Episode?
    var episode: Episode? {
        get {
            return _episode
        }
        set {
            _episode = newValue
            let placeholder = UIImage(color: UIColor.whiteColor())
            self.thumbnailView.setImageWithURL(NSURL(string: newValue!.picture.url), placeholderImage: placeholder)
            self.titleLabel.text = newValue!.title
        }
    }

    let thumbnailView = UIImageView()
    let titleLabel = UILabel()
    let bookmarkView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.thumbnailView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bookmarkView)

        self.thumbnailView.snp_makeConstraints { make in
            make.width.equalTo(71)
            make.height.equalTo(42)
        }

        self.titleLabel.font = UIFont.systemFontOfSize(13)
        self.titleLabel.snp_makeConstraints { make in
            make.left.equalTo(80)
            make.top.equalTo(13)
            make.width.lessThanOrEqualTo(230)
        }

        self.bookmarkView.image = UIImage(named: "icon_bookmark")
        self.bookmarkView.snp_makeConstraints { make in
            make.left.equalTo(275)
            make.width.equalTo(10)
            make.height.equalTo(16)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class var height: CGFloat {
        return 42
    }
}
