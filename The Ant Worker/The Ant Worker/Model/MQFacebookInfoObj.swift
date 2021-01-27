//
//  MMFacebookInfoObj.swift
//
//  Created by Tung Nguyen on 4/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MQFacebookInfoObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMMFacebookInfoObjInternalIdentifierKey: String = "id"
  private let kMMFacebookInfoObjNameKey: String = "name"
  private let kMMFacebookInfoObjEmailKey: String = "email"

  // MARK: Properties
  public var internalIdentifier: String?
  public var name: String?
  public var email: String?

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
    internalIdentifier = json[kMMFacebookInfoObjInternalIdentifierKey].string
    name = json[kMMFacebookInfoObjNameKey].string
    email = json[kMMFacebookInfoObjEmailKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kMMFacebookInfoObjInternalIdentifierKey] = value }
    if let value = name { dictionary[kMMFacebookInfoObjNameKey] = value }
    if let value = email { dictionary[kMMFacebookInfoObjEmailKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMMFacebookInfoObjInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kMMFacebookInfoObjNameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kMMFacebookInfoObjEmailKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kMMFacebookInfoObjInternalIdentifierKey)
    aCoder.encode(name, forKey: kMMFacebookInfoObjNameKey)
    aCoder.encode(email, forKey: kMMFacebookInfoObjEmailKey)
  }

}
