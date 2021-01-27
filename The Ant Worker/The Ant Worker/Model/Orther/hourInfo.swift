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
    func initFromString(fomat:String = "HH/mm",value:String){
//        let firstIndexH = fomat.firstIndex(of: "H")?.encodedOffset ?? 0
//        let lastIndexH = fomat.lastIndex(of: "H")?.encodedOffset ?? 0
//
//        let firstIndexM = fomat.firstIndex(of: "m")?.encodedOffset ?? 0
//        let lastIndexM = fomat.lastIndex(of: "m")?.encodedOffset ?? 0
//        hour = Int(String(value[firstIndexH...lastIndexH])) ?? 0
//        minute = Int(String(value[firstIndexM...lastIndexM])) ?? 0
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
