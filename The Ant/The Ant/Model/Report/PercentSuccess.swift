//
//  PercentSuccess.swift
//
//  Created by Quyet on 8/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class PercentSuccess: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPercentSuccessIconKey: String = "icon"
  private let kPercentSuccessValueKey: String = "value"

  // MARK: Properties
  public var icon: String?
  public var value: String?

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
    icon = json[kPercentSuccessIconKey].string
    value = json[kPercentSuccessValueKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = icon { dictionary[kPercentSuccessIconKey] = value }
    if let value = value { dictionary[kPercentSuccessValueKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.icon = aDecoder.decodeObject(forKey: kPercentSuccessIconKey) as? String
    self.value = aDecoder.decodeObject(forKey: kPercentSuccessValueKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(icon, forKey: kPercentSuccessIconKey)
    aCoder.encode(value, forKey: kPercentSuccessValueKey)
  }

}
