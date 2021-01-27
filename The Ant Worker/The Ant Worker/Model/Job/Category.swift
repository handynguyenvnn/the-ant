//
//  Category.swift
//
//  Created by Tung Nguyen on 7/8/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Category: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCategoryAvatarKey: String = "avatar"
  private let kCategoryStatusKey: String = "status"
  private let kCategoryNameKey: String = "name"
  private let kCategoryInternalIdentifierKey: String = "id"
  private let kCategoryParentKey: String = "parent"
  private let kCategorySortKey: String = "sort"

  // MARK: Properties
  public var avatar: String?
  public var status: Int?
  public var name: String?
  public var internalIdentifier: String?
  public var parent: String?
  public var sort: String?

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
    avatar = json[kCategoryAvatarKey].string
    status = json[kCategoryStatusKey].int
    name = json[kCategoryNameKey].string
    internalIdentifier = json[kCategoryInternalIdentifierKey].string
    parent = json[kCategoryParentKey].string
    sort = json[kCategorySortKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = avatar { dictionary[kCategoryAvatarKey] = value }
    if let value = status { dictionary[kCategoryStatusKey] = value }
    if let value = name { dictionary[kCategoryNameKey] = value }
    if let value = internalIdentifier { dictionary[kCategoryInternalIdentifierKey] = value }
    if let value = parent { dictionary[kCategoryParentKey] = value }
    if let value = sort { dictionary[kCategorySortKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.avatar = aDecoder.decodeObject(forKey: kCategoryAvatarKey) as? String
    self.status = aDecoder.decodeObject(forKey: kCategoryStatusKey) as? Int
    self.name = aDecoder.decodeObject(forKey: kCategoryNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kCategoryInternalIdentifierKey) as? String
    self.parent = aDecoder.decodeObject(forKey: kCategoryParentKey) as? String
    self.sort = aDecoder.decodeObject(forKey: kCategorySortKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(avatar, forKey: kCategoryAvatarKey)
    aCoder.encode(status, forKey: kCategoryStatusKey)
    aCoder.encode(name, forKey: kCategoryNameKey)
    aCoder.encode(internalIdentifier, forKey: kCategoryInternalIdentifierKey)
    aCoder.encode(parent, forKey: kCategoryParentKey)
    aCoder.encode(sort, forKey: kCategorySortKey)
  }

}
