//
//  WebtoonListViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Snappy
import UIKit

enum WebtoonListType {
    case Mine, All
}

class WebtoonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private struct CellID {
        static let Webtoon = "Webtoon"
    }

    private var _listType = WebtoonListType.All
    var listType: WebtoonListType {
        get {
            return _listType
        }
        set {
            _listType = newValue
            self.title = (newValue == WebtoonListType.All ? "검색" : "내 웹툰")
        }
    }

    let weekdaySelector = UISegmentedControl()
    let tableView = UITableView()
    var webtoons: RLMArray?

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let toolbar = UIToolbar()
        self.view.addSubview(toolbar)
        toolbar.snp_makeConstraints { make in
            make.top.equalTo(64)
            make.width.equalTo(self.view)
        }

        let toolbarBorder = UIView()
        toolbarBorder.backgroundColor = UIColor.lightGrayColor()
        toolbar.addSubview(toolbarBorder)
        toolbarBorder.snp_makeConstraints { make in
            make.width.equalTo(toolbar)
            make.height.equalTo(0.5)
            make.bottom.equalTo(toolbar)
        }

        toolbar.addSubview(self.weekdaySelector)
        let options = ["All", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Con"]
        for i in 0...(options.count - 1) {
            self.weekdaySelector.insertSegmentWithTitle(__(options[i]), atIndex: i, animated: false)
        }
        self.weekdaySelector.addTarget(self, action: "filterWebtoons", forControlEvents: UIControlEvents.ValueChanged)
        self.weekdaySelector.snp_makeConstraints { make in
            make.centerX.equalTo(toolbar)
            make.centerY.equalTo(toolbar).with.offset(-1)
            make.width.equalTo(toolbar).with.offset(-20)
            return
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if self.weekdaySelector.selectedSegmentIndex == UISegmentedControlNoSegment {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate())
            let weekday = components.weekday
            self.weekdaySelector.selectedSegmentIndex = (weekday >= 2 ? weekday - 1 : 7)
        }

        filterWebtoons()
    }

    func filterWebtoons() {
        let options = ["all", "mon", "tue", "wed", "thu", "fri", "sat", "sun", "concluded"]
        let option = options[self.weekdaySelector.selectedSegmentIndex]

        var predicate = ""
        if self.listType == WebtoonListType.Mine {
            predicate += "subscribing=1"
        }
        if self.weekdaySelector.selectedSegmentIndex > 0 {
            if predicate != "" {
                predicate += " AND "
            }
            predicate += "\(option)=1"
        }

        if predicate == "" {
            self.webtoons = Webtoon.allObjects()
        } else {
            self.webtoons = Webtoon.objectsWithPredicate(NSPredicate(format: predicate))
        }
        self.tableView.reloadData()
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        let detailViewController = WebtoonDetailViewController()
        detailViewController.webtoon = self.webtoons!.objectAtIndex(UInt(indexPath.row)) as? Webtoon
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
