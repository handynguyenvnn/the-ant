//
//  STteacherListObj.swift
//
//  Created by Tung Nguyen on 8/12/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class STteacherListObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSTteacherListObjInternalIdentifierKey: String = "id"
  private let kSTteacherListObjNameKey: String = "name"

  // MARK: Properties
  public var internalIdentifier: String?
  public var name: String?

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
    internalIdentifier = json[kSTteacherListObjInternalIdentifierKey].string
    name = json[kSTteacherListObjNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kSTteacherListObjInternalIdentifierKey] = value }
    if let value = name { dictionary[kSTteacherListObjNameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kSTteacherListObjInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kSTteacherListObjNameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kSTteacherListObjInternalIdentifierKey)
    aCoder.encode(name, forKey: kSTteacherListObjNameKey)
  }

}
