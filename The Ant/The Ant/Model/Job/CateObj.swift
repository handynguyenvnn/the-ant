//
//  CateObj.swift
//
//  Created by Quyet on 7/8/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CateObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCateObjStatusKey: String = "status"
  private let kCateObjNameKey: String = "name"
  private let kCateObjInternalIdentifierKey: String = "id"
  private let kCateObjParentKey: String = "parent"
  private let kCateObjSortKey: String = "sort"
  private let kCateObjAvatarKey: String = "avatar"

  // MARK: Properties
  public var status: Int?
  public var name: String?
  public var internalIdentifier: String?
  public var parent: String?
  public var sort: String?
  public var avatar: String?
    var isSeclect:Bool = false
    var isTmp:Bool = false
    var isFav:Bool = false

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
    status = json[kCateObjStatusKey].int
    name = json[kCateObjNameKey].string
    internalIdentifier = json[kCateObjInternalIdentifierKey].string
    parent = json[kCateObjParentKey].string
    sort = json[kCateObjSortKey].string
    avatar = json[kCateObjAvatarKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kCateObjStatusKey] = value }
    if let value = name { dictionary[kCateObjNameKey] = value }
    if let value = internalIdentifier { dictionary[kCateObjInternalIdentifierKey] = value }
    if let value = parent { dictionary[kCateObjParentKey] = value }
    if let value = sort { dictionary[kCateObjSortKey] = value }
    if let value = avatar { dictionary[kCateObjAvatarKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kCateObjStatusKey) as? Int
    self.name = aDecoder.decodeObject(forKey: kCateObjNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kCateObjInternalIdentifierKey) as? String
    self.parent = aDecoder.decodeObject(forKey: kCateObjParentKey) as? String
    self.sort = aDecoder.decodeObject(forKey: kCateObjSortKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kCateObjAvatarKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kCateObjStatusKey)
    aCoder.encode(name, forKey: kCateObjNameKey)
    aCoder.encode(internalIdentifier, forKey: kCateObjInternalIdentifierKey)
    aCoder.encode(parent, forKey: kCateObjParentKey)
    aCoder.encode(sort, forKey: kCateObjSortKey)
    aCoder.encode(avatar, forKey: kCateObjAvatarKey)
  }

}
