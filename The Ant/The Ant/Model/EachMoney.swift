//
//  EachMoney.swift
//
//  Created by Quyet on 9/12/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class EachMoney: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kEachMoneyStartTimeKey: String = "start_time"
  private let kEachMoneyPriceKey: String = "price_shift"
  private let kEachMoneyEndTimeKey: String = "end_time"

  // MARK: Properties
  public var startTime: String?
  public var price_shift: Int64?
  public var endTime: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    startTime = json[kEachMoneyStartTimeKey].string
    price_shift = json[kEachMoneyPriceKey].int64
    endTime = json[kEachMoneyEndTimeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = startTime { dictionary[kEachMoneyStartTimeKey] = value }
    if let value = price_shift { dictionary[kEachMoneyPriceKey] = value }
    if let value = endTime { dictionary[kEachMoneyEndTimeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.startTime = aDecoder.decodeObject(forKey: kEachMoneyStartTimeKey) as? String
    self.price_shift = aDecoder.decodeObject(forKey: kEachMoneyPriceKey) as? Int64
    self.endTime = aDecoder.decodeObject(forKey: kEachMoneyEndTimeKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(startTime, forKey: kEachMoneyStartTimeKey)
    aCoder.encode(price_shift, forKey: kEachMoneyPriceKey)
    aCoder.encode(endTime, forKey: kEachMoneyEndTimeKey)
  }

}
