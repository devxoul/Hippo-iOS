//
//  WebtoonDetailViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/5/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class WebtoonDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private struct CellID {
        static let Episode = "Episode"
    }

    var webtoon: Webtoon? {
        get {
            return self.detailView.webtoon
        }
        set {
            self.detailView.webtoon = newValue
            self.episodes = self.webtoon?.episodes
            println("episodes: \(self.episodes)")
            self.tableView.reloadData()
        }
    }
    var episodes: RLMArray?

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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(EpisodeCell.self, forCellReuseIdentifier: CellID.Episode)
        self.tableView.snp_makeConstraints { make in
            make.top.equalTo(self.detailView.snp_bottom)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view)
        }
    }

    func fetchEpisodes() {
        if self.webtoon? == nil {
            return
        }

        Request.sendToRoute("webtoon_episodes", parameters: ["webtoon_id": self.webtoon!.id],
            success: { (operation, responseObject) -> Void in
                let data = responseObject["data"] as [NSDictionary]

                RLMRealm.defaultRealm().beginWriteTransaction()
                for episodeData in data {
                    let episode = Episode.createOrUpdateInDefaultRealmWithObject(episodeData)
                    self.webtoon?.episodes.addObject(episode)
                }
                RLMRealm.defaultRealm().commitWriteTransaction()

                self.episodes = self.webtoon?.episodes
                self.tableView.reloadData()
            },
            failure: { (operation, error) -> Void in

            }
        )
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.episodes == nil {
            return 0
        }
        return Int(self.episodes!.count)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EpisodeCell.height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.Episode) as? EpisodeCell
        cell!.episode = self.episodes!.objectAtIndex(UInt(indexPath.row)) as? Episode
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}