//
//  TeacherListObj.swift
//
//  Created by Tung Nguyen on 8/12/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class TeacherListObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kTeacherListObjInternalIdentifierKey: String = "id"
  private let kTeacherListObjNameKey: String = "name"

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
    internalIdentifier = json[kTeacherListObjInternalIdentifierKey].string
    name = json[kTeacherListObjNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kTeacherListObjInternalIdentifierKey] = value }
    if let value = name { dictionary[kTeacherListObjNameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kTeacherListObjInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kTeacherListObjNameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kTeacherListObjInternalIdentifierKey)
    aCoder.encode(name, forKey: kTeacherListObjNameKey)
  }

}
