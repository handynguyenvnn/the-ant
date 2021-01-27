//
//  ListAskObj.swift
//
//  Created by Anh Quan on 7/31/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ListAskObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kListAskObjAContentKey: String = "aContent"
  private let kListAskObjAidKey: String = "aid"
  private let kListAskObjQidKey: String = "qid"
  private let kListAskObjQContentKey: String = "qContent"

  // MARK: Properties
  public var aContent: String?
  public var aid: String?
  public var qid: String?
  public var qContent: String?
    var isExpand = false

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
    aContent = json[kListAskObjAContentKey].string
    aid = json[kListAskObjAidKey].string
    qid = json[kListAskObjQidKey].string
    qContent = json[kListAskObjQContentKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = aContent { dictionary[kListAskObjAContentKey] = value }
    if let value = aid { dictionary[kListAskObjAidKey] = value }
    if let value = qid { dictionary[kListAskObjQidKey] = value }
    if let value = qContent { dictionary[kListAskObjQContentKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.aContent = aDecoder.decodeObject(forKey: kListAskObjAContentKey) as? String
    self.aid = aDecoder.decodeObject(forKey: kListAskObjAidKey) as? String
    self.qid = aDecoder.decodeObject(forKey: kListAskObjQidKey) as? String
    self.qContent = aDecoder.decodeObject(forKey: kListAskObjQContentKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(aContent, forKey: kListAskObjAContentKey)
    aCoder.encode(aid, forKey: kListAskObjAidKey)
    aCoder.encode(qid, forKey: kListAskObjQidKey)
    aCoder.encode(qContent, forKey: kListAskObjQContentKey)
  }

}
