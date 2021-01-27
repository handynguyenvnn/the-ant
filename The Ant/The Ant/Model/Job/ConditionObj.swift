//
//  ConditionObj.swift
//
//  Created by Quyet on 7/8/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ConditionObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kConditionObjInternalIdentifierKey: String = "id"
  private let kConditionObjPriceKey: String = "price"
  private let kConditionObjTitleKey: String = "title"

  // MARK: Properties
  public var internalIdentifier: String?
  public var price: Int?
  public var title: String?
    var isSelected:Bool = false

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
  */
  public init(json: JSON) {
    internalIdentifier = json[kConditionObjInternalIdentifierKey].string
    price = json[kConditionObjPriceKey].int
    title = json[kConditionObjTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kConditionObjInternalIdentifierKey] = value }
    if let value = price { dictionary[kConditionObjPriceKey] = value }
    if let value = title { dictionary[kConditionObjTitleKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kConditionObjInternalIdentifierKey) as? String
    self.price = aDecoder.decodeObject(forKey: kConditionObjPriceKey) as? Int
    self.title = aDecoder.decodeObject(forKey: kConditionObjTitleKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kConditionObjInternalIdentifierKey)
    aCoder.encode(price, forKey: kConditionObjPriceKey)
    aCoder.encode(title, forKey: kConditionObjTitleKey)
  }

}
