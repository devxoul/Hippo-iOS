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

class WebtoonListViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

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
            self.title = newValue == WebtoonListType.All ? __("Search") : __("My Webtoons")
        }
    }

    let weekdaySelector = UISegmentedControl()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let tapRecognizer = UITapGestureRecognizer()

    var webtoons: RLMArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(WebtoonCell.self, forCellReuseIdentifier: CellID.Webtoon)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.size.equalTo(self.view)
            return
        }

        self.searchBar.delegate = self
        self.searchBar.placeholder = __("Search")
        self.view.addSubview(self.searchBar)

        let toolbar = UIToolbar()
        self.view.addSubview(toolbar)
        toolbar.snp_makeConstraints { make in
            make.top.equalTo(64)
            make.width.equalTo(self.view)
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

        self.searchBar.snp_makeConstraints { make in
            make.top.equalTo(toolbar.snp_bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(44)
        }

        self.tapRecognizer.addTarget(self, action: "viewDidTap")
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

    // MARK: - Filter

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

        if !self.searchBar.text.isEmpty {
            if predicate != "" {
                predicate += " AND "
            }
            predicate += "title CONTAINS[c] '\(self.searchBar.text)'"
        }

        if predicate == "" {
            self.webtoons = Webtoon.allObjects()
        } else {
            self.webtoons = Webtoon.objectsWithPredicate(NSPredicate(format: predicate))
        }
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDeleagate

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

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder() {
            self.searchBar.resignFirstResponder()
        }

        if scrollView.contentOffset.y <= -152 {
            self.searchBar.y = 108
        } else if scrollView.contentOffset.y > -152 {
            self.searchBar.y = -44 - scrollView.contentOffset.y
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.tableView.addGestureRecognizer(self.tapRecognizer)
        return true
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterWebtoons()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.viewDidTap()
    }

    // MARK: - UITapGestureRecognizer

    func viewDidTap() {
        self.tableView.removeGestureRecognizer(self.tapRecognizer)
        self.searchBar.resignFirstResponder()
    }
}
