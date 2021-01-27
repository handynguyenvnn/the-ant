//
//  TAPostObj.swift
//
//  Created by Tung Nguyen on 7/10/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class TAPostObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kTAPostObjStatusKey: String = "status"
  private let kTAPostObjInternalIdentifierKey: String = "id"
  private let kTAPostObjAvatarKey: String = "avatar"
  private let kTAPostObjTitleKey: String = "title"
  private let kTAPostObjCategoryKey: String = "category"
    private let kTAPostObjCreatedAtKey: String = "created_at"

  // MARK: Properties
  public var status: Int?
  public var internalIdentifier: String?
  public var avatar: String?
  public var title: String?
  public var category: [Category]?
    public var createdAt:String?
    public var content:String?

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
    status = json[kTAPostObjStatusKey].int
    internalIdentifier = json[kTAPostObjInternalIdentifierKey].string
    avatar = json[kTAPostObjAvatarKey].string
    title = json[kTAPostObjTitleKey].string
    if let items = json[kTAPostObjCategoryKey].array { category = items.map { Category(json: $0) } }
    createdAt = json[kTAPostObjCreatedAtKey].string
    content = json["content"].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kTAPostObjStatusKey] = value }
    if let value = internalIdentifier { dictionary[kTAPostObjInternalIdentifierKey] = value }
    if let value = avatar { dictionary[kTAPostObjAvatarKey] = value }
    if let value = title { dictionary[kTAPostObjTitleKey] = value }
    if let value = category { dictionary[kTAPostObjCategoryKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kTAPostObjStatusKey) as? Int
    self.internalIdentifier = aDecoder.decodeObject(forKey: kTAPostObjInternalIdentifierKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kTAPostObjAvatarKey) as? String
    self.title = aDecoder.decodeObject(forKey: kTAPostObjTitleKey) as? String
    self.category = aDecoder.decodeObject(forKey: kTAPostObjCategoryKey) as? [Category]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kTAPostObjStatusKey)
    aCoder.encode(internalIdentifier, forKey: kTAPostObjInternalIdentifierKey)
    aCoder.encode(avatar, forKey: kTAPostObjAvatarKey)
    aCoder.encode(title, forKey: kTAPostObjTitleKey)
    aCoder.encode(category, forKey: kTAPostObjCategoryKey)
  }

}
