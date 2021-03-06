//
//  WebtoonViewerViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/9/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class WebtoonViewerViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate,
UIGestureRecognizerDelegate {

    private var _episode: Episode?
    var episode: Episode? {
        get {
            return self._episode
        }
        set {
            self._episode = newValue
            self.title = newValue!.title
            self._prevEpisode = newValue!.prevEpisode()
            self._nextEpisode = newValue!.nextEpisode()
            self.prevButton.enabled = self.prevEpisode? != nil
            self.nextButton.enabled = self.nextEpisode? != nil
            self.reload()
        }
    }

    private var _prevEpisode: Episode?
    var prevEpisode: Episode? {
        return self._prevEpisode
    }

    private var _nextEpisode: Episode?
    var nextEpisode: Episode? {
        return self._nextEpisode
    }

    private var _barsHidden = false
    var barsHidden: Bool {
        get {
            return _barsHidden
        }
        set {
            self._barsHidden = newValue
            UIView.animateWithDuration(0.25, animations: {
                self.navigationController?.navigationBar.y = newValue ? -44 : 20
                self.navigationController?.toolbar.y = newValue ? self.view.height : self.view.height - 44
                return
            })
        }
    }

    private var _lastTime = NSDate()
    private var _lastOffsetY = CGFloat()

    let webView = UIWebView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    let reloadButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: nil, action: "reload")
    let prevButton = UIBarButtonItem(title: __("Prev"), style: .Plain, target: nil, action: "loadPrevEpisode")
    let nextButton = UIBarButtonItem(title: __("Next"), style: .Plain, target: nil, action: "loadNextEpisode")

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "webViewDidSwipe")
        swipeRecognizer.delegate = self
        swipeRecognizer.direction = .Up | .Down

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "webViewDidTap")
        tapRecognizer.delegate = self

        self.view.addSubview(self.webView)
        self.webView.delegate = self
        self.webView.scrollView.delegate = self
        self.webView.backgroundColor = UIColor.whiteColor()
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.webView.addGestureRecognizer(swipeRecognizer)
        self.webView.addGestureRecognizer(tapRecognizer)
        self.webView.snp_makeConstraints { make in
            make.top.equalTo(self.view).with.offset(-64)
            make.bottom.equalTo(self.view).with.offset(44)
            make.width.equalTo(self.view)
        }

        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp_makeConstraints { make in
            make.center.equalTo(self.view)
            return
        }

        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.reloadButton.target = self
        self.prevButton.target = self
        self.nextButton.target = self
        self.toolbarItems = [reloadButton, spacer, self.prevButton, self.nextButton]

        self.reload()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.barsHidden = false
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    // MARK: - Load

    func reload() {
        if self.episode? == nil {
            return
        }

        self.reloadButton.enabled = false

        let request = NSURLRequest(URL: NSURL(string:self.episode!.mobileUrl))
        self.webView.loadRequest(request)
    }

    func read() {
        if self.episode? == nil {
            return
        }

        if self.episode!.read {
            return
        }

        let alreadRead = self.episode!.read
        let originalBookmark = self.episode!.webtoon.bookmark

        if !alreadRead {
            RLMRealm.defaultRealm().beginWriteTransaction()
            self.episode!.read = true
            RLMRealm.defaultRealm().commitWriteTransaction()
        }

        if originalBookmark != self.episode!.id {
            self.episode!.webtoon.updateBookmark()
        }

        Request.sendToRoute("read_episode", parameters: ["episode_id": self.episode!.id],
            success: { (operation, responseObject) -> Void in

            },
            failure: { (operation, error) -> Void in
                if !alreadRead {
                    RLMRealm.defaultRealm().beginWriteTransaction()
                    self.episode!.read = false
                    self.episode!.webtoon.bookmark = originalBookmark
                    RLMRealm.defaultRealm().commitWriteTransaction()
                }
            }
        )
    }

    func loadPrevEpisode() {
        self.episode = self.prevEpisode
        self.reload()
    }

    func loadNextEpisode() {
        self.episode = self.nextEpisode
        self.reload()
    }

    // MARK: - UIWebViewDelegate

    func webView(webView: UIWebView, shouldStartLoadWithRequest: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
        self.activityIndicatorView.startAnimating()
        self.barsHidden = false
        return true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.reloadButton.enabled = true
        self.activityIndicatorView.stopAnimating()
        self.read()

        dispatch_after(1, dispatch_get_main_queue(), {
            self.barsHidden = true
        })
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        let timedelta = -self._lastTime.timeIntervalSinceNow
        let velocity = (contentOffsetY - self._lastOffsetY) / CGFloat(timedelta)

        if contentOffsetY >= 0 && contentOffsetY <= contentHeight {
            if self._lastOffsetY < scrollView.contentOffset.y {
                // scroll down
                self.barsHidden = true
            }
            else if velocity < -1000 || contentOffsetY + scrollView.height - 44 == contentHeight {
                // scroll up - fast scroll or scroll to bottom
                self.barsHidden = false
            }
        }

        self._lastOffsetY = contentOffsetY
        self._lastTime = NSDate()
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func webViewDidSwipe() {
        // if smart toon
        if self.webView.scrollView.contentSize.height - 10 == self.webView.bounds.size.height {
            self.barsHidden = false
        }
    }

    func webViewDidTap() {
        self.barsHidden = !self.barsHidden
    }
}
