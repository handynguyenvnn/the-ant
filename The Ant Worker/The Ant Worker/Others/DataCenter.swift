//
//  HDDataCenter.swift
// 
//
//  Created by mac on 12/16/17.
//  Copyright © 2017 ViniCorp. All rights reserved.
//

import UIKit

let QUALITY_VALUE = "QUALITY & VALUE ANALYSIS"
let PERFORMANCE_ENGINEERING = "PERFORMANCE & ENGINEERING"
let COMFORT_CONVENIENCE = "COMFORT & CONVENIENCE"
let DIMENSIONS = "DIMENSIONS"
class DataCenter: NSObject {
    var token:String = ""
    var isFirstLogin:NSInteger = 1
    var currentUser: UserObj?
    var listCate:[CateObj]?
    var currentCate:CateObj?
    var listStatus = [STATUS_JOB.NEW,STATUS_JOB.InProgress,STATUS_JOB.CANCEL,STATUS_JOB.DONE]
    class var sharedInstance :DataCenter {
        struct Singleton {
            static let instance = DataCenter.init()
        }
        return Singleton.instance
    }
    
    func downloadGuidline(block:@escaping CompletionBlock)
    {
//        PServices.shareInstance.getGuidline { (dataReturn, message, errorCode) in
//            block(dataReturn,message,errorCode)
//        }
    }
}
