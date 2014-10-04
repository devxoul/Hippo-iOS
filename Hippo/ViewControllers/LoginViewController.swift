//
//  LoginViewController.swift
//  Hippo
//
//  Created by 전수열 on 10/4/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController {

    var finishBlock: (() -> ())?

    var loadingLabel = UILabel()
    var loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var loadingMessage: String {
        set {
            self.loadingLabel.text = newValue
            self.loadingLabel.sizeToFit()
        }
        get {
            return self.loadingLabel.text!
        }
    }

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()

        self.loadingLabel.textColor = UIColor.darkGrayColor()
        self.view.addSubview(self.loadingLabel)
        self.loadingLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self.view).with.offset(-self.loadingIndicatorView.width / 2 - 4)
            make.centerY.equalTo(self.view)
            return
        }

        self.loadingIndicatorView.startAnimating()
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp_makeConstraints { make in
            make.left.equalTo(self.loadingLabel.snp_right).with.offset(10)
            make.centerY.equalTo(self.view)
            return
        }
    }

    func tryLogin() {
        self.loadingMessage = __("Retrieving login information...")

        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey(UserDefaultsName.Username)
        if username != nil {
            let password = SSKeychain.passwordForService(Hippo, account: username)
            if password != nil {
                let params = [
                    "username": username,
                    "password": password
                ]
                // /login/username
                return
            }
        }

        var UUID = defaults.stringForKey(UserDefaultsName.UUID)
        if UUID == nil {
            UUID = UIDevice.currentDevice().identifierForVendor.UUIDString
        }
        let params = [
            "uuid": UUID!,
            "os": "iOS"
        ]

        println("Try to device login with uuid: \(UUID!)")

        Request.sendToRoute("login_device", parameters: params,
            success: { (operation, responseObject) -> Void in
                println("Device login success.")
                self.fetchWebtoons()
            },
            failure: { (operation, error) -> Void in
                if operation.response.statusCode == 403 {
                    println("Try to join with device")
                    Request.sendToRoute(
                        "join_device",
                        parameters: params,
                        success: { (operation, responseObject) -> Void in
                            println("Device join success.")
                            self.fetchWebtoons()
                        },
                        failure: { (operation, error) -> Void in
                            println("Device join failure: \(operation.responseObject)")
                            self.loadingMessage = __("기기 정보 등록 실패")
                        }
                    )
                } else {
                    println("Device login failed: \(operation.responseObject)")
                    self.loadingMessage = __("로그인 실패")
                }
            }
        )
    }

    func fetchWebtoons() {
        self.loadingLabel.text = __("Loading webtoons...")
        self.loadingLabel.sizeToFit()

        let params = [
            "username": "me",
            "limit": "99999",
        ]

        Request.sendToRoute("all_webtoons", parameters: params,
            success: { (operation, responseObject) in
                let data = responseObject["data"] as [NSDictionary]

                let allWebtoons = Webtoon.allObjects()

                RLMRealm.defaultRealm().beginWriteTransaction()
                for webtoonData in data {
                    Webtoon.createOrUpdateInDefaultRealmWithObject(webtoonData)
                }
                RLMRealm.defaultRealm().commitWriteTransaction()

                if self.finishBlock != nil {
                    self.finishBlock?()
                }
            },
            failure: { (operation, error) in
                self.loadingMessage = __("웹툰 정보 로딩 실패")
            }
        )
    }
}
