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
    ("login_username",  "POST", "/login/username"),
    ("login_facebook",  "POST", "/login/facebook"),
    ("logout",          "POST", "/logout"),

    // webtoons
    ("user_webtoons", "GET", "/<username>/webtoons"),
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

    class func fromName(name: String, withParameter: [String: AnyObject!]) -> Route? {
        for row in _map {
            if row.0 == name {
                return Route(name: row.0, method: row.1, pattern: row.2)
            }
        }
        return nil
    }
}
