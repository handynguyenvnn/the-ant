//
//  UserWorkers.swift
//
//  Created by Quyet on 7/11/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserWorkers: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserWorkersInternalIdentifierKey: String = "id"
  private let kUserWorkersNameKey: String = "name"
  private let kUserWorkersAvatarKey: String = "avatar"
    private let kUserWorkersPriceKey: String = "price"
    private let kUserWorkerspercentDoneKey: String = "percent_done"
    private let kUserWorkerspriceProgressKey: String = "price_progress"
    private let kProfileObjstatusColorKey: String = "status_color"
    private let kMQStoreObjStatusKey: String = "status"

  // MARK: Properties
  public var internalIdentifier: String?
  public var name: String?
  public var avatar: String?
    public var status_color: String?
    public var statusText:String?
    public var price: Int64?
    public var percent_done: Int?
    public var price_progress: Int64?
    public var isRate:Bool?
    public var rateObj:RateObj?
    public var status: Int?
     var isChecked = false
    var isCheckedStar:Bool = false
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
    internalIdentifier = json[kUserWorkersInternalIdentifierKey].string
    name = json[kUserWorkersNameKey].string
    status_color = json[kProfileObjstatusColorKey].string
    price = json[kUserWorkersPriceKey].int64
    percent_done = json[kUserWorkerspercentDoneKey].int
    price_progress = json[kUserWorkerspriceProgressKey].int64
    avatar = json[kUserWorkersAvatarKey].string
    status = json[kMQStoreObjStatusKey].int
    statusText = json["status_text"].string
    isRate = json["is_rate"].bool
    rateObj = RateObj.init(object:json["rate"])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kUserWorkersInternalIdentifierKey] = value }
    if let value = name { dictionary[kUserWorkersNameKey] = value }
    if let value = avatar { dictionary[kUserWorkersAvatarKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kUserWorkersInternalIdentifierKey) as? String
    self.name = aDecoder.decodeObject(forKey: kUserWorkersNameKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kUserWorkersAvatarKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kUserWorkersInternalIdentifierKey)
    aCoder.encode(name, forKey: kUserWorkersNameKey)
    aCoder.encode(avatar, forKey: kUserWorkersAvatarKey)
  }

}
