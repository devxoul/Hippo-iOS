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
    var allWebtoonListViewController = WebtoonListViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions: [NSObject : AnyObject]?) -> Bool {
        self.window.frame = UIScreen.mainScreen().bounds
        self.window.backgroundColor = UIColor.whiteColor()
        self.window.makeKeyAndVisible()

        println("DebugOptions.DropRealmOnAppLaunch: \(DebugOptions.DropRealmOnAppLaunch)")

        if DebugOptions.DropRealmOnAppLaunch {
            println("Drop Realm")
            self.dropRealm()
        }

        Request.baseURLString = "http://hippo.xoul.kr"
        Request.HTTPHeaderFields = [
            "Accept": "application/json"
        ]

        showLoginViewController()
        return true
    }

    func dropRealm() {
        NSFileManager.defaultManager().removeItemAtPath(RLMRealm.defaultRealmPath(), error: nil)
    }

    func showLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.tryLogin()
        loginViewController.finishBlock = {
            self.initTabBar()
        }
        self.window.rootViewController = loginViewController
    }

    func initTabBar() {
        self.myWebtoonListViewController.listType = WebtoonListType.Mine
        self.allWebtoonListViewController.listType = WebtoonListType.All

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: self.myWebtoonListViewController),
            UINavigationController(rootViewController: self.allWebtoonListViewController),
        ]
        self.window.rootViewController = tabBarController
    }
}
