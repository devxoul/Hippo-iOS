//
//  Webtoon.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class Webtoon: RLMObject {
    dynamic var id: Int = 0
    dynamic var portal: String = ""
    dynamic var portal_id: String = ""
    dynamic var title: String = ""
    dynamic var introduction: String = ""
    dynamic var picture: Picture = Picture()
    dynamic var artists = RLMArray(objectClassName: Artist.className())
    dynamic var mon: Bool = false
    dynamic var tue: Bool = false
    dynamic var wed: Bool = false
    dynamic var thu: Bool = false
    dynamic var fri: Bool = false
    dynamic var sat: Bool = false
    dynamic var sun: Bool = false
    dynamic var concluded: Bool = false
    dynamic var subscribing: Bool = false

    override class func primaryKey() -> String {
        return "id"
    }
}
