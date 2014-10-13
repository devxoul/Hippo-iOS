//
//  SettingsViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/14/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {

    struct CellID {
        static let Default = "Default"
    }

    let tableView = UITableView(frame: CGRectZero, style: .Grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellID.Default)
        self.tableView.snp_makeConstraints { make in
            make.size.equalTo(self.view)
            return
        }
    }

    // MARK: - UITableView

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.Default) as? UITableViewCell
        cell!.textLabel!.text = __("Clear all contents...")
        cell!.textLabel!.textColor = self.view.tintColor
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        UIActionSheet(
            title: __("Application will be CLOSED after done."),
            delegate: self,
            cancelButtonTitle: __("Cancel"),
            destructiveButtonTitle: __("Clear all contents")
        ).showInView(self.view)
    }

    // MARK - UIActionSheetDelegate

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == Int(actionSheet.destructiveButtonIndex) {
            RealmHelper.dropRealm()
            RealmHelper.clearRevision()
            exit(0)
        }
    }
}