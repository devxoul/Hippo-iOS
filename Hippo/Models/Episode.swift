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
    dynamic var picture: Picture?
    dynamic var desktop_url = ""
    dynamic var mobile_url = ""
    dynamic var read = false

    dynamic var webtoon = Webtoon()

    override class func primaryKey() -> String {
        return "id"
    }

    func prevEpisode() -> Episode? {
        let episodes = self.webtoon.sortedEpisodes()
        let index = episodes.indexOfObject(self)
        if index == episodes.count - 1 || Int(index) == NSNotFound {
            return nil
        }
        return episodes.objectAtIndex(index + 1) as? Episode
    }

    func nextEpisode() -> Episode? {
        let episodes = self.webtoon.sortedEpisodes()
        let index = episodes.indexOfObject(self)
        if index == 0 || Int(index) == NSNotFound {
            return nil
        }
        return episodes.objectAtIndex(index - 1) as? Episode
    }
}
