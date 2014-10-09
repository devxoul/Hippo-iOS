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
            self.tableView.reloadData()
        }
    }
    var episodes: RLMArray?

    let subscribeButton = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    let detailView = WebtoonDetailView()
    let tableView = UITableView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

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
            make.bottom.equalTo(self.view).with.offset(-self.tabBarController!.tabBar.height)
            make.width.equalTo(self.view)
        }

        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp_makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).with.offset(self.detailView.height - 15)
            return
        }

        self.fetchEpisodesIfNeeded()
    }

    func fetchEpisodesIfNeeded() {
        if self.webtoon?.episodes.count == 0 {
            self.fetchEpisodes()
        }
    }

    func fetchEpisodes() {
        println("Fetch episodes.")

        self.tableView.hidden = true
        self.activityIndicatorView.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

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
                self.tableView.hidden = false
                self.activityIndicatorView.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            },
            failure: { (operation, error) -> Void in
                self.tableView.hidden = false
                self.activityIndicatorView.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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

        self.hidesBottomBarWhenPushed = true;

        let viewer = WebtoonViewerViewController()
        viewer.episode = self.episodes?.objectAtIndex(UInt(indexPath.row)) as? Episode
        self.navigationController?.pushViewController(viewer, animated: true)

        self.hidesBottomBarWhenPushed = false;
    }
}
