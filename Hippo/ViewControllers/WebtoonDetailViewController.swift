//
//  WebtoonDetailViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/5/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class WebtoonDetailViewController: UIViewController {

    var webtoon: Webtoon? {
        get {
            return self.detailView.webtoon
        }
        set {
            self.detailView.webtoon = newValue
        }
    }
    var episodes = [Episode]()

    let subscribeButton = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    let detailView = WebtoonDetailView()
    let tableView = UITableView()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = self.webtoon?.title
        self.navigationItem.rightBarButtonItem = self.subscribeButton

        self.view.addSubview(self.detailView)
        self.detailView.snp_makeConstraints { make in
            make.top.equalTo(64)
            make.width.equalTo(self.view)
            make.height.equalTo(self.detailView.height)
        }

        self.view.addSubview(self.tableView)
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
        self.tableView.snp_makeConstraints { make in
            make.top.equalTo(self.detailView.snp_bottom)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view)
        }
    }

//    func fetchEpisodes() {
//        Request.sendToRoute(<#name: String#>, parameters: <#NSDictionary#>, success: <#(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void##(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void#>, failure: <#(operation: AFHTTPRequestOperation!, error: NSError!) -> Void##(operation: AFHTTPRequestOperation!, error: NSError!) -> Void#>)
//    }
}