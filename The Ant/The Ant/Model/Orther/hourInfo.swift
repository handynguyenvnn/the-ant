//
//  hourInfo.swift
//  Mori Mori
//
//  Created by Khiem on 2018-12-14.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
public class TimeHour:NSObject {
    var hour:Int
    var minute:Int
    
    init(hourValue:Int = 0,minuteValue:Int = 0) {
        hour = hourValue
        minute = minuteValue
    }
//    func initFromString(fomat:String = "HH/mm",value:String){
//        if let date = Utilitys.getDateFromText(fomat, value)
//        {
//            hour = Int(Utilitys.getTextFromDate("HH", date) ?? "") ?? 0
//            minute = Int(Utilitys.getTextFromDate("mm", date) ?? "") ?? 0
//        }
//       
//    }
    func initFromString(fomat:String = "HH/mm",value:String){
        if let date = Utilitys.getDateFromText(fomat, value)
        {
            hour = Int(Utilitys.getTextFromDate("HH", date) ?? "") ?? 0
            minute = Int(Utilitys.getTextFromDate("mm", date) ?? "") ?? 0
        }
        
    }
    
    func add(hourValue:Int,minuteValue:Int) -> TimeHour{
        let result = TimeHour(hourValue: 0,minuteValue: 0)
        
        let totalMinute:Int = (hour + hourValue) * 60 + (minute + minuteValue)
        result.minute = totalMinute % 60
        result.hour = totalMinute / 60
     
        return result
    }
    
    func show() -> String {
        let strHour = hour < 10 ? "0\(hour)" : "\(hour)"
        let strMinute = minute < 10 ? "0\(minute)": "\(minute)"
        return "\(strHour):\(strMinute)"
    }
    
    /**
     return hour value
     */
    static func - (left: TimeHour, right: TimeHour) -> Float {
        let timeLeft = (left.hour ) * 60 + (left.minute)
        let timeRight = (right.hour ) * 60 + (right.minute)
        return (Float(timeLeft - timeRight) / 60.0)
    }
    /**
     return Bool
     */
    static func > (left: TimeHour, right: TimeHour) -> Bool {
        let timeLeft = (left.hour ) * 60 + (left.minute)
        let timeRight = (right.hour ) * 60 + (right.minute)
        return timeLeft > timeRight
    }
    
    /**
     return Bool
     */
    static func < (left: TimeHour, right: TimeHour) -> Bool {
        let timeLeft = (left.hour ) * 60 + (left.minute)
        let timeRight = (right.hour ) * 60 + (right.minute)
        return timeLeft < timeRight
    }
    /**
     return Bool
     */
    static func >= (left: TimeHour, right: TimeHour) -> Bool {
        let timeLeft = (left.hour ) * 60 + (left.minute)
        let timeRight = (right.hour ) * 60 + (right.minute)
        return timeLeft >= timeRight
    }
    
    /**
     return Bool
     */
    static func <= (left: TimeHour, right: TimeHour) -> Bool {
        let timeLeft = (left.hour ) * 60 + (left.minute)
        let timeRight = (right.hour ) * 60 + (right.minute)
        return timeLeft <= timeRight
    }
}
