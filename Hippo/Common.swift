//
//  Common.swift
//  Hippo
//
//  Created by 전수열 on 10/4/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

let Hippo = "Hippo"

struct UserDefaultsName {
    static let Username = "Username"
    static let VendorRevisions = "VendorRevisions"
}

func __(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
