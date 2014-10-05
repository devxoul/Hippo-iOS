//
//  Episode.swift
//  Hippo
//
//  Created by 전수열 on 10/5/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class Episode: RLMObject {
    dynamic var id = 0
    dynamic var no = 0
    dynamic var title = ""
    dynamic var picture = Picture()
    dynamic var desktop_url = ""
    dynamic var mobile_url = ""
    dynamic var read = false

    override class func primaryKey() -> String {
        return "id"
    }
}
