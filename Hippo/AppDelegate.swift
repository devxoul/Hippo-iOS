//
//  AppDelegate.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window = UIWindow()
    var myWebtoonListViewController = WebtoonListViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions: [NSObject : AnyObject]?) -> Bool {
        self.window.frame = UIScreen.mainScreen().bounds
        self.window.backgroundColor = UIColor.whiteColor()
        self.window.makeKeyAndVisible()

        Request.baseURLString = "http://127.0.0.1:8000"
        Request.HTTPHeaderFields = [
            "Accept": "application/json"
        ]

        initTabBar()

        return true
    }

    func initTabBar() {
        let nav = UINavigationController(rootViewController: self.myWebtoonListViewController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nav]
        self.window.rootViewController = tabBarController
    }
}
