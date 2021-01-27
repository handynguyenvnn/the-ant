//
//  ListBankObj.swift
//
//  Created by Quyet on 10/3/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ListBankObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kListBankObjNameKey: String = "name"
  private let kListBankObjInternalIdentifierKey: String = "id"
  private let kListBankObjShortNameKey: String = "short_name"
  private let kListBankObjCodeKey: String = "code"
  private let kListBankObjImageKey: String = "image"

  // MARK: Properties
  public var name: String?
  public var internalIdentifier: String?
  public var shortName: String?
  public var code: String?
  public var image: String?

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
    name = json[kListBankObjNameKey].string
    internalIdentifier = json[kListBankObjInternalIdentifierKey].string
    shortName = json[kListBankObjShortNameKey].string
    code = json[kListBankObjCodeKey].string
    image = json[kListBankObjImageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kListBankObjNameKey] = value }
    if let value = internalIdentifier { dictionary[kListBankObjInternalIdentifierKey] = value }
    if let value = shortName { dictionary[kListBankObjShortNameKey] = value }
    if let value = code { dictionary[kListBankObjCodeKey] = value }
    if let value = image { dictionary[kListBankObjImageKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kListBankObjNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kListBankObjInternalIdentifierKey) as? String
    self.shortName = aDecoder.decodeObject(forKey: kListBankObjShortNameKey) as? String
    self.code = aDecoder.decodeObject(forKey: kListBankObjCodeKey) as? String
    self.image = aDecoder.decodeObject(forKey: kListBankObjImageKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kListBankObjNameKey)
    aCoder.encode(internalIdentifier, forKey: kListBankObjInternalIdentifierKey)
    aCoder.encode(shortName, forKey: kListBankObjShortNameKey)
    aCoder.encode(code, forKey: kListBankObjCodeKey)
    aCoder.encode(image, forKey: kListBankObjImageKey)
  }

}
