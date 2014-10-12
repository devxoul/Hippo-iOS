//
//  WebtoonDetailView.swift
//  Hippo
//
//  Created by 전수열 on 10/5/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class WebtoonDetailView: UIView {

    private var _webtoon: Webtoon?
    var webtoon: Webtoon? {
        get {
            return _webtoon?
        }
        set {
            _webtoon = newValue
            let placeholder = UIImage(color: UIColor.whiteColor())
            if newValue!.picture? == nil {
                self.thumbnailView.image = placeholder
            } else {
                let url = NSURL(string: newValue!.picture!.url)
                self.thumbnailView.setImageWithURL(url, placeholderImage: placeholder)
            }
            self.titleLabel.text = newValue!.title
            self.artistLabel.text = newValue!.artistText()
            self.portalIconView.image = UIImage(named: "icon_\(newValue!.portal)")
            self.weekdayLabel.text = newValue!.weekdayText()
        }
    }

    let thumbnailView = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    let portalIconView = UIImageView()
    let weekdayLabel = UILabel()
    let borderView = UIView()

    convenience override init() {
        self.init(frame: CGRectMake(0, 0, 320, 60))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: 0xf6f6f6, alpha: 0.8)

        self.addSubview(self.thumbnailView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.artistLabel)
        self.addSubview(self.portalIconView)
        self.addSubview(self.weekdayLabel)
        self.addSubview(self.borderView)

        self.thumbnailView.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.size.equalTo(CGSizeMake(55, 60))
            return
        }

        self.titleLabel.snp_makeConstraints { make in
            make.left.equalTo(64)
            make.top.equalTo(4)
            make.width.lessThanOrEqualTo(190)
            return
        }

        self.artistLabel.font = UIFont.systemFontOfSize(12)
        self.artistLabel.textColor = UIColor.darkGrayColor()
        self.artistLabel.snp_makeConstraints { make in
            make.left.equalTo(64)
            make.top.equalTo(24)
            make.width.lessThanOrEqualTo(190)
            return
        }

        self.portalIconView.snp_makeConstraints { make in
            make.left.equalTo(64)
            make.top.equalTo(41)
            make.size.equalTo(CGSizeMake(12, 12))
            return
        }

        self.weekdayLabel.font = UIFont.systemFontOfSize(11)
        self.weekdayLabel.textColor = UIColor.darkGrayColor()
        self.weekdayLabel.snp_makeConstraints { make in
            make.left.equalTo(81)
            make.top.equalTo(41)
            make.width.lessThanOrEqualTo(170)
            return
        }

        self.borderView.backgroundColor = UIColor(hex: 0xa7a7a7, alpha: 0.9)
        self.borderView.snp_makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self)
            return
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}