//
//  ListAboutObj.swift
//
//  Created by Anh Quan on 7/31/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ListAboutObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kListAboutObjStatusKey: String = "status"
  private let kListAboutObjTitleKey: String = "title"
  private let kListAboutObjInternalIdentifierKey: String = "_id"
  private let kListAboutObjSortKey: String = "sort"

  // MARK: Properties
  public var status: Int?
  public var title: String?
  public var internalIdentifier: String?
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
    status = json[kListAboutObjStatusKey].int
    title = json[kListAboutObjTitleKey].string
    internalIdentifier = json[kListAboutObjInternalIdentifierKey].string
    sort = json[kListAboutObjSortKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kListAboutObjStatusKey] = value }
    if let value = title { dictionary[kListAboutObjTitleKey] = value }
    if let value = internalIdentifier { dictionary[kListAboutObjInternalIdentifierKey] = value }
    if let value = sort { dictionary[kListAboutObjSortKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kListAboutObjStatusKey) as? Int
    self.title = aDecoder.decodeObject(forKey: kListAboutObjTitleKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kListAboutObjInternalIdentifierKey) as? String
    self.sort = aDecoder.decodeObject(forKey: kListAboutObjSortKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kListAboutObjStatusKey)
    aCoder.encode(title, forKey: kListAboutObjTitleKey)
    aCoder.encode(internalIdentifier, forKey: kListAboutObjInternalIdentifierKey)
    aCoder.encode(sort, forKey: kListAboutObjSortKey)
  }

}
