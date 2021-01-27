//
//  MQStoreObj.swift
//
//  Created by Tung Nguyen on 6/17/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MQStoreObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMQStoreObjStatusKey: String = "status"
  private let kMQStoreObjStartTimeKey: String = "start_time"
  private let kMQStoreObjLngKey: String = "lng"
  private let kMQStoreObjInternalIdentifierKey: String = "id"
  private let kMQStoreObjNameKey: String = "name"
  private let kMQStoreObjEndTimeKey: String = "end_time"
  private let kMQStoreObjAddressKey: String = "address"
  private let kMQStoreObjAvatarKey: String = "avatar"
  private let kMQStoreObjPhoneKey: String = "phone"
  private let kMQStoreObjLatKey: String = "lat"

  // MARK: Properties
  public var status: Int?
    public var timeOpen:String?
  public var lng: Float?
  public var internalIdentifier: Int?
  public var name: String?
  public var address: String?
  public var avatar: String?
  public var phone: String?
  public var lat: Float?
    public var distance: Int?

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
    status = json[kMQStoreObjStatusKey].int
    timeOpen = json["time_open"].string
    lng = json[kMQStoreObjLngKey].float
    internalIdentifier = json[kMQStoreObjInternalIdentifierKey].int
    name = json[kMQStoreObjNameKey].string
    address = json[kMQStoreObjAddressKey].string
    avatar = json[kMQStoreObjAvatarKey].string
    phone = json[kMQStoreObjPhoneKey].string
    lat = json[kMQStoreObjLatKey].float
    distance = json["distance"].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kMQStoreObjStatusKey] = value }
    if let value = lng { dictionary[kMQStoreObjLngKey] = value }
    if let value = internalIdentifier { dictionary[kMQStoreObjInternalIdentifierKey] = value }
    if let value = name { dictionary[kMQStoreObjNameKey] = value }
    if let value = address { dictionary[kMQStoreObjAddressKey] = value }
    if let value = avatar { dictionary[kMQStoreObjAvatarKey] = value }
    if let value = phone { dictionary[kMQStoreObjPhoneKey] = value }
    if let value = lat { dictionary[kMQStoreObjLatKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kMQStoreObjStatusKey) as? Int
    self.lng = aDecoder.decodeObject(forKey: kMQStoreObjLngKey) as? Float
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMQStoreObjInternalIdentifierKey) as? Int
    self.name = aDecoder.decodeObject(forKey: kMQStoreObjNameKey) as? String
    self.address = aDecoder.decodeObject(forKey: kMQStoreObjAddressKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kMQStoreObjAvatarKey) as? String
    self.phone = aDecoder.decodeObject(forKey: kMQStoreObjPhoneKey) as? String
    self.lat = aDecoder.decodeObject(forKey: kMQStoreObjLatKey) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kMQStoreObjStatusKey)
    aCoder.encode(lng, forKey: kMQStoreObjLngKey)
    aCoder.encode(internalIdentifier, forKey: kMQStoreObjInternalIdentifierKey)
    aCoder.encode(name, forKey: kMQStoreObjNameKey)
    aCoder.encode(address, forKey: kMQStoreObjAddressKey)
    aCoder.encode(avatar, forKey: kMQStoreObjAvatarKey)
    aCoder.encode(phone, forKey: kMQStoreObjPhoneKey)
    aCoder.encode(lat, forKey: kMQStoreObjLatKey)
  }

}
