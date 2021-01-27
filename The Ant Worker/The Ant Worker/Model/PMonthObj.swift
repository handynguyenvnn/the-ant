//
//  PMonthObj.swift
//  Pavico
//
//  Created by MacBook on 5/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
let MAX_MONTH_CHECK = 6
class PMonthObj: NSObject {
    var month:NSInteger = 0
    var year:NSInteger = 0
    var quarter:Int = 0
    var titleMonthYear = ""
    var titleQuarter = ""
    class func getListTitleFromCurrentDate(currentDate:Date?)->[PMonthObj]
    {
        var listMonth:[PMonthObj] = [PMonthObj]()
        var date = currentDate
        if date == nil
        {
            date = NSDate() as Date
        }
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date ?? Date())
        let year = calendar.component(.year, from: date ?? Date())
        for i in 0...5
        {
            let monthYearObj:PMonthObj = PMonthObj()
            monthYearObj.month = month - i > 0 ? month - i: 12 + (i - month)
            if monthYearObj.month > month
            {
                monthYearObj.year = year - 1
            }
            else
            {
                monthYearObj.year = year
            }
            monthYearObj.titleMonthYear = "Tháng \(monthYearObj.month)" // - \(monthYearObj.year)
            listMonth.append(monthYearObj)
        }
        return listMonth
    }
    class func getCurrentQuater(currentDate:Date?)->Int{
        let month = Calendar.current.component(.month, from: currentDate ?? Date())
        switch month {
        case 1...3:
            return 1
        case 4...6:
            return 2
        case 7...9:
            return 3
        case 10...12:
            return 4
        default:
            return 0
        }
    }
   class func getListQuarter() -> [PMonthObj] {
        var listMonth:[PMonthObj] = [PMonthObj]()
        for i in 1...4
        {
            let monthYearObj:PMonthObj = PMonthObj()
            monthYearObj.quarter = i
            monthYearObj.titleQuarter = "Quý \(monthYearObj.quarter)"
            listMonth.append(monthYearObj)
        }
        return listMonth
    }
    
    
    func getQuarter() -> String {
        switch month {
        case 1...3:
            return "1"
        case 4...6:
            return "2"
        case 7...9:
            return "3"
        case 10...12:
            return "4"
        default:
            return ""
        }
        return ""
    }
    func display() -> String {
        let mounthSTR = (self.month < 10) ? "0\(self.month)" : "\(self.month)"
        return "\(self.year)-\(mounthSTR)"
    }
}
