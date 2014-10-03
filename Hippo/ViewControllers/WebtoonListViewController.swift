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

struct CellID {
    static let Webtoon = "Webtoon"
}

class WebtoonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let weekdaySelector = UISegmentedControl(items: ["전체", "월", "화", "수", "목", "금", "토", "일", "완결"])
    let tableView = UITableView()
    var webtoons: RLMArray?

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

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate())
        let weekday = components.weekday
        self.weekdaySelector.selectedSegmentIndex = (weekday >= 2 ? weekday - 1 : 7)

        self.tableView.registerClass(WebtoonCell.self, forCellReuseIdentifier: CellID.Webtoon)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.size.equalTo(self.view)
            return
        }


        fetchWebtoons()
    }

    func fetchWebtoons() {
        let params = [
            "username": "me",
        ]
        Request.sendToRoute("all_webtoons", parameters: params,
            success: { (operation, responseObject) in
                let data = responseObject["data"] as [NSDictionary]

                RLMRealm.defaultRealm().beginWriteTransaction()
                for webtoonData in data {
                    Webtoon.createInDefaultRealmWithObject(webtoonData)
                }
                RLMRealm.defaultRealm().commitWriteTransaction()
                self.webtoons = Webtoon.allObjects()
                self.tableView.reloadData()
            },
            failure: { (operation, error) in
                println("err: \(operation.responseObject)")
            }
        );
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.webtoons == nil {
            return 0
        }
        return Int(self.webtoons!.count)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WebtoonCell.height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.Webtoon) as? WebtoonCell
        cell?.webtoon = self.webtoons?.objectAtIndex(UInt(indexPath.row)) as? Webtoon
        return cell!
    }
}
