//
//  TimeWorkObj.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import Foundation
class TimeWorkObj: NSObject {
    var startTime:TimeHour?
    var endTime:TimeHour?
    var startDate:Date?
    var endDate:Date?
    var price_shift:Int64?
    override init() {
        
    }
    func initWithString(strStartTime:String,strEndTime:String) -> TimeWorkObj{
        let obj = TimeWorkObj()
        obj.startDate = Utilitys.stringToDate(strDate: strStartTime)
         obj.endDate = Utilitys.stringToDate(strDate: strEndTime)
        return obj
    }
}

