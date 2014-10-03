//
//  WebtoonListViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Snappy
import UIKit

extension UINavigationBar {
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        for subview in self.subviews {
            let subPoint = subview.convertPoint(point, fromView:self)
            let result = (subview as UIView).hitTest(subPoint, withEvent: event)
            if result != nil {
                return result
            }
        }
        return super.hitTest(point, withEvent: event)
    }
}

class WebtoonListViewController: UIViewController {

    let weekdaySelector = UISegmentedControl(items: ["전체", "월", "화", "수", "목", "금", "토", "일", "완결"])
    let tableView = UITableView()
    var webtoons = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "내 웹툰"

        let navBarBackground = self.navigationController?.navigationBar.subviews[0] as UIView
        navBarBackground.height = 108
        navBarBackground.userInteractionEnabled = true
        navBarBackground.addSubview(self.weekdaySelector)
        self.weekdaySelector.snp_makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(navBarBackground).offset(-10)
            make.bottom.equalTo(navBarBackground).equalTo(-12)
            return
        }
    }
}
