//
//  Route.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

private let _map = [
    // login
    ("login_device",    "POST", "/login/device"),
    ("login_username",  "POST", "/login/username"),
    ("login_facebook",  "POST", "/login/facebook"),
    ("logout",          "POST", "/logout"),

    // join
    ("join_device",     "POST", "/join/device"),
    ("join_username",   "POST", "/join/username"),

    // revisions
    ("revisions_vendors",  "GET", "/revisions/vendors"),
    ("revisions_webtoons", "GET", "/revisions/subscribing-webtoons"),

    // webtoons
    ("all_webtoons",    "GET", "/webtoons"),
    ("user_webtoons",   "GET", "/<username>/webtoons"),

    ("subscribe_webtoon",   "PUT",    "/webtoons/<webtoon_id>/subscribe"),
    ("unsubscribe_webtoon", "DELETE", "/webtoons/<webtoon_id>/subscribe"),

    // episodes
    ("webtoon_episodes", "GET", "/webtoons/<webtoon_id>/episodes"),
    ("read_episode",    "PUT", "/episodes/<episode_id>/read"),
]

class Route {

    var name: String!
    var method: String!
    var pattern: String!

    init(name: String, method: String, pattern: String) {
        self.name = name
        self.method = method
        self.pattern = pattern
    }

    class func fromName(name: String) -> Route? {
        for row in _map {
            if row.0 == name {
                return Route(name: row.0, method: row.1, pattern: row.2)
            }
        }
        return nil
    }
}
