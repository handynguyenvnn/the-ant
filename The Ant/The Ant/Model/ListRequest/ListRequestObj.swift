//
//  ListRequestObj.swift
//
//  Created by Quyet on 9/3/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ListRequestObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kListRequestObjInternalIdentifierKey: String = "id"
  private let kListRequestObjNameKey: String = "name"
  private let kListRequestObjListUserKey: String = "list_user"
    private let kListUserAvatarKey: String = "avatar"

  // MARK: Properties
  public var internalIdentifier: String?
  public var name: String?
    public var avatar: String?
  public var listUser: [ListUser]?
    var isExpand:Bool = false
    var isSeclect:Bool = false
    public var isChecked = false
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
    internalIdentifier = json[kListRequestObjInternalIdentifierKey].string
    name = json[kListRequestObjNameKey].string
    avatar = json[kListUserAvatarKey].string
    if let items = json[kListRequestObjListUserKey].array { listUser = items.map { ListUser(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kListRequestObjInternalIdentifierKey] = value }
    if let value = name { dictionary[kListRequestObjNameKey] = value }
    if let value = listUser { dictionary[kListRequestObjListUserKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kListRequestObjInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kListRequestObjNameKey) as? String
    self.listUser = aDecoder.decodeObject(forKey: kListRequestObjListUserKey) as? [ListUser]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kListRequestObjInternalIdentifierKey)
    aCoder.encode(name, forKey: kListRequestObjNameKey)
    aCoder.encode(listUser, forKey: kListRequestObjListUserKey)
  }

}
