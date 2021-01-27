//
//  PriceObj.swift
//
//  Created by Quyet on 9/12/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class PriceObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPriceObjTotalMoneyKey: String = "total_money"
  private let kPriceObjEachMoneyKey: String = "each_money"

  // MARK: Properties
  public var totalMoney: Int?
  public var eachMoney: [EachMoney]?

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
    totalMoney = json[kPriceObjTotalMoneyKey].int
    if let items = json[kPriceObjEachMoneyKey].array { eachMoney = items.map { EachMoney(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = totalMoney { dictionary[kPriceObjTotalMoneyKey] = value }
    if let value = eachMoney { dictionary[kPriceObjEachMoneyKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.totalMoney = aDecoder.decodeObject(forKey: kPriceObjTotalMoneyKey) as? Int
    self.eachMoney = aDecoder.decodeObject(forKey: kPriceObjEachMoneyKey) as? [EachMoney]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(totalMoney, forKey: kPriceObjTotalMoneyKey)
    aCoder.encode(eachMoney, forKey: kPriceObjEachMoneyKey)
  }

}
