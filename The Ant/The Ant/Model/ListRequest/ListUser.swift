//
//  ListUser.swift
//
//  Created by Quyet on 9/3/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ListUser: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kListUserInternalIdentifierKey: String = "id"
  private let kListUserNameKey: String = "name"
  private let kListUserAvatarKey: String = "avatar"

  // MARK: Properties
  public var internalIdentifier: String?
  public var name: String?
  public var avatar: String?
    var isChecked:Bool = false

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
     */public override init() {
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
    internalIdentifier = json[kListUserInternalIdentifierKey].string
    name = json[kListUserNameKey].string
    avatar = json[kListUserAvatarKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kListUserInternalIdentifierKey] = value }
    if let value = name { dictionary[kListUserNameKey] = value }
    if let value = avatar { dictionary[kListUserAvatarKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kListUserInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kListUserNameKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kListUserAvatarKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kListUserInternalIdentifierKey)
    aCoder.encode(name, forKey: kListUserNameKey)
    aCoder.encode(avatar, forKey: kListUserAvatarKey)
  }

}
