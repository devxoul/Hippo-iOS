//
//  APIClient.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

struct RequestInfo {
    var method: String?
    var URLString: String?
    var parameters: NSDictionary?
}

class Request {

    private struct __ {
        static var baseURLString = ""
        static let manager = AFHTTPRequestOperationManager()
    }

    class var baseURLString: String {
        set(baseURLString) {
            __.baseURLString = baseURLString
        }
        get {
            return __.baseURLString
        }
    }

    class var manager: AFHTTPRequestOperationManager {
        return __.manager
    }

    class func infoWithRouteName(name: String, parameters: NSDictionary) -> RequestInfo! {
        let route = Route.fromName(name)
        var info = RequestInfo(method: route?.method, URLString: route?.pattern, parameters: parameters)

        for (k, v) in parameters {
            let pat = "<\(k)>"
            let range = info.URLString?.rangeOfString(pat, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            if range? != nil && range?.isEmpty == false {
                info.URLString?.replaceRange(range!, with: v as String)
                let params = info.parameters?.mutableCopy() as NSMutableDictionary
                params.removeObjectForKey(k)
                info.parameters = params
            }
        }

        return info
    }

    class func operationWithRouteName(name: String, parameters: NSDictionary,
        success: (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void,
        failure: (operation: AFHTTPRequestOperation!, error: NSError!) -> Void) -> AFHTTPRequestOperation {
            let info = self.infoWithRouteName(name, parameters: parameters)
            let request = self.manager.requestSerializer.requestWithMethod(
                info.method,
                URLString: self.baseURLString + info.URLString!,
                parameters: info.parameters,
                error: nil
            )
            let operation = manager.HTTPRequestOperationWithRequest(request, success: success, failure: failure)
            return operation
    }

    class func sendToRoute(name: String, parameters: NSDictionary,
        success: (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void,
        failure: (operation: AFHTTPRequestOperation!, error: NSError!) -> Void) -> AFHTTPRequestOperation {
            let operation = self.operationWithRouteName(
                name,
                parameters: parameters,
                success: success,
                failure: failure
            )
            self.manager.operationQueue.addOperation(operation)
            return operation
    }
}
