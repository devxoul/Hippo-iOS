//
//  APIClient.swift
//  Hippo
//
//  Created by 전수열 on 10/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

typealias RequestParams = [String: AnyObject!]
typealias RequestSuccessBlock = (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void
typealias RequestFailureBlock = (operation: AFHTTPRequestOperation!, error: NSError!) -> Void

struct RequestInfo {
    var method: String?
    var URLString: String?
    var parameters: RequestParams?
}

class APIClient {

    class var manager: AFHTTPRequestOperationManager {
        struct __ {
            static let manager = AFHTTPRequestOperationManager()
        }
        return __.manager
    }

    class func requestInfoWithRouteName(name: String, parameters: RequestParams) -> RequestInfo! {
        let route = Route.fromName(name)
        var info = RequestInfo(method: route?.method, URLString: route?.pattern, parameters: parameters)

        for (k, v) in parameters {
            let pat = "<\(k)>"
            let range = info.URLString?.rangeOfString(pat, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            if range? != nil && range?.isEmpty == false {
                info.URLString?.replaceRange(range!, with: v as String)
                info.parameters?.removeValueForKey(k)
            }
        }

        return info
    }

    class func requestWithRouteName(name: String, parameters: RequestParams) -> NSURLRequest! {
        let info = self.requestInfoWithRouteName(name, parameters: parameters)
        let request = self.manager.requestSerializer.requestWithMethod(
            info.method,
            URLString: info.URLString,
            parameters: info.parameters,
            error: nil
        )
        return request
    }

    class func operationWithRouteName(name: String, parameters: RequestParams, success: RequestSuccessBlock, failure: RequestFailureBlock) -> AFHTTPRequestOperation {
        let request = self.requestWithRouteName(name, parameters: parameters)
        let operation = manager.HTTPRequestOperationWithRequest(request, success: success, failure: failure)
        return operation
    }

    class func startOperationWithRouteName(name: String, parameters: RequestParams, success: RequestSuccessBlock, failure: RequestFailureBlock) -> AFHTTPRequestOperation {
        let operation = self.operationWithRouteName(name, parameters: parameters, success: success, failure: failure)
        self.manager.operationQueue.addOperation(operation)
        return operation
    }
}
