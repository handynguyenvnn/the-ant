//
//  POCNotificationObj.swift
//  POC
//
//  Created by "longhm" on 1/23/19.
//  Copyright © 2019 HVN. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationObj: NSObject {
    var notificationId:String?
    var notificaitonTitle:String?
    var notiticationTime:String?
    var notificationSummary:String?
    var notificationContent:String?
    var notificationIcon:String?
    var notificationType:Int?
    var notificationStatus:String?
    var notificationIsRead:NSInteger?
    var dateTime:Date?
    var isRead:Bool = false
    var jid:String?
    private struct SerializationKeys {
        static let notificationId = "id"
        static let notificaitonTitle = "title"
        static let notificationSummary = "price"
        static let notificationContent = "content"
        static let notificationIcon = "image"
        static let notificationType = "type"
        static let notificationStatus = "status"
        static let notiticationTime = "created_at"
        static let notificationIsRead = "is_read"
    }
    public required override init() {
        super.init()
    }
    public required init(json: JSON) {
        notificationId = json[SerializationKeys.notificationId].string
        notificaitonTitle = json[SerializationKeys.notificaitonTitle].string
        notificationSummary = json[SerializationKeys.notificationSummary].string
        notificationContent = json[SerializationKeys.notificationContent].string
        notificationType = json[SerializationKeys.notificationType].int
        notificationStatus = json[SerializationKeys.notificationStatus].string
        notificationIcon = json[SerializationKeys.notificationIcon].string
        notiticationTime = json[SerializationKeys.notiticationTime].string
        notificationIsRead = json[SerializationKeys.notificationIsRead].intValue
        self.isRead = (notificationIsRead ?? 0) == 1 ? true:false
        jid = json["jid"].string
    }
}
