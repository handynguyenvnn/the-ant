//
//  TimeWork.swift
//
//  Created by Tung Nguyen on 7/8/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class TimeWork: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kTimeWorkStartTimeKey: String = "start_time"
  private let kTimeWorkDayWorkKey: String = "day_work"
  private let kTimeWorkEndTimeKey: String = "end_time"

  // MARK: Properties
   public var startTime: String?
  public var dayWork: String?
   public var endTime: String?
    var timeWork = TimeWorkObj()
    var startDate:Date?
    var endDate:Date?
    var priceShift:Int64?
    
  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
    public override init() {
        super.init()
    }
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  *///yyyy-MM-dd hh:mm
  public init(json: JSON) {
    super.init()
    startTime =  json[kTimeWorkStartTimeKey].string
    dayWork = json[kTimeWorkDayWorkKey].string
    endTime =  json[kTimeWorkEndTimeKey].string
    startDate = Utilitys.getDateFromText(FORMAT_DATE_FULL_TIME, startTime)
    endDate = Utilitys.getDateFromText(FORMAT_DATE_FULL_TIME, endTime)
    priceShift = json["price_shift"].int64
    if startTime != nil
    {
        //timeWork.startTime?.initFromString(fomat: "HH:mm", value: startTime ?? "")
        timeWork.startDate = Utilitys.getDateFromText("yyyy-MM-dd HH:mm", startTime)
    }
    if endTime != nil{
        //timeWork.endTime?.initFromString(fomat: "HH:mm", value: endTime ?? "")
        timeWork.endDate = Utilitys.getDateFromText("yyyy-MM-dd HH:mm", endTime)
    }
    
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = startTime { dictionary[kTimeWorkStartTimeKey] = value }
    if let value = dayWork { dictionary[kTimeWorkDayWorkKey] = value }
    //if let value = dayWork { dictionary[kTimeWorkDayWorkKey] = value.dictionaryRepresentation()}
    if let value = endTime { dictionary[kTimeWorkEndTimeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.startTime = aDecoder.decodeObject(forKey: kTimeWorkStartTimeKey) as? String
    self.dayWork = aDecoder.decodeObject(forKey: kTimeWorkDayWorkKey) as? String
    //self.dayWork = aDecoder.decodeObject(forKey: kTimeWorkDayWorkKey) as? TimeHour
    self.endTime = aDecoder.decodeObject(forKey: kTimeWorkEndTimeKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(startTime, forKey: kTimeWorkStartTimeKey)
    aCoder.encode(dayWork, forKey: kTimeWorkDayWorkKey)
    aCoder.encode(endTime, forKey: kTimeWorkEndTimeKey)
  }

}
