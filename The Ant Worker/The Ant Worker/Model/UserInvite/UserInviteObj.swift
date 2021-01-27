//
//  UserInviteObj.swift
//
//  Created by Quyet on 10/7/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserInviteObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserInviteObjNameKey: String = "name"
  private let kUserInviteObjUserKey: String = "user"
  private let kUserInviteObjUpdatedAtKey: String = "updated_at"
  private let kUserInviteObjAddressKey: String = "address"
  private let kUserInviteObjHrNameKey: String = "hr_name"
  private let kUserInviteObjCidKey: String = "cid"
  private let kUserInviteObjLatKey: String = "lat"
  private let kUserInviteObjPriceKey: String = "price"
  private let kUserInviteObjUidKey: String = "uid"
  private let kUserInviteObjTimeWorkKey: String = "time_work"
  private let kUserInviteObjContentKey: String = "content"
  private let kUserInviteObjStatusKey: String = "status"
  private let kUserInviteObjHrPhoneKey: String = "hr_phone"
  private let kUserInviteObjInternalIdentifierKey: String = "_id"
  private let kUserInviteObjLngKey: String = "lng"
  private let kUserInviteObjUpdatedByKey: String = "updatedBy"
  private let kUserInviteObjInviteIdKey: String = "invite_id"
  private let kUserInviteObjCreatedAtKey: String = "created_at"
  private let kUserInviteObjPersonKey: String = "person"
  private let kUserInviteObjIsFullKey: String = "is_full"
  private let kUserInviteObjCreatedByKey: String = "createdBy"
    private let kUserInviteObjpersionBidKey: String = "persionBid"
    private let kMQStoreObjtotalHourKey: String = "total_hour"
    private let kMQUserObjtotalPriceKey = "total_price"

  // MARK: Properties
  public var name: String?
  public var user: User?
  public var updatedAt: String?
  public var address: String?
  public var hrName: String?
  public var cid: String?
  public var lat: Float?
  public var price: Int?
  public var uid: String?
  public var timeWork: [TimeWork]?
  public var content: String?
  public var status: Int?
  public var hrPhone: String?
  public var internalIdentifier: String?
  public var lng: Float?
  public var updatedBy: String?
  public var inviteId: String?
  public var createdAt: String?
  public var person: Int?
  public var isFull: Int?
  public var createdBy: String?
    public var persionBid: Int?
    public var total_hour: String?
    public var total_price: Int64?

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
    total_price = json[kMQUserObjtotalPriceKey].int64 ?? Int64(json[kMQUserObjtotalPriceKey].string ?? "")
    total_hour = json[kMQStoreObjtotalHourKey].string
    persionBid = json[kUserInviteObjpersionBidKey].int
    name = json[kUserInviteObjNameKey].string
    user = User(json: json[kUserInviteObjUserKey])
    updatedAt = json[kUserInviteObjUpdatedAtKey].string
    address = json[kUserInviteObjAddressKey].string
    hrName = json[kUserInviteObjHrNameKey].string
    cid = json[kUserInviteObjCidKey].string
    lat = json[kUserInviteObjLatKey].float
    price = json[kUserInviteObjPriceKey].int
    uid = json[kUserInviteObjUidKey].string
    if let items = json[kUserInviteObjTimeWorkKey].array { timeWork = items.map { TimeWork(json: $0) } }
    content = json[kUserInviteObjContentKey].string
    status = json[kUserInviteObjStatusKey].int
    hrPhone = json[kUserInviteObjHrPhoneKey].string
    internalIdentifier = json[kUserInviteObjInternalIdentifierKey].string
    lng = json[kUserInviteObjLngKey].float
    updatedBy = json[kUserInviteObjUpdatedByKey].string
    inviteId = json[kUserInviteObjInviteIdKey].string
    createdAt = json[kUserInviteObjCreatedAtKey].string
    person = json[kUserInviteObjPersonKey].int
    isFull = json[kUserInviteObjIsFullKey].int
    createdBy = json[kUserInviteObjCreatedByKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kUserInviteObjNameKey] = value }
    if let value = user { dictionary[kUserInviteObjUserKey] = value.dictionaryRepresentation() }
    if let value = updatedAt { dictionary[kUserInviteObjUpdatedAtKey] = value }
    if let value = address { dictionary[kUserInviteObjAddressKey] = value }
    if let value = hrName { dictionary[kUserInviteObjHrNameKey] = value }
    if let value = cid { dictionary[kUserInviteObjCidKey] = value }
    if let value = lat { dictionary[kUserInviteObjLatKey] = value }
    if let value = price { dictionary[kUserInviteObjPriceKey] = value }
    if let value = uid { dictionary[kUserInviteObjUidKey] = value }
    if let value = timeWork { dictionary[kUserInviteObjTimeWorkKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = content { dictionary[kUserInviteObjContentKey] = value }
    if let value = status { dictionary[kUserInviteObjStatusKey] = value }
    if let value = hrPhone { dictionary[kUserInviteObjHrPhoneKey] = value }
    if let value = internalIdentifier { dictionary[kUserInviteObjInternalIdentifierKey] = value }
    if let value = lng { dictionary[kUserInviteObjLngKey] = value }
    if let value = updatedBy { dictionary[kUserInviteObjUpdatedByKey] = value }
    if let value = inviteId { dictionary[kUserInviteObjInviteIdKey] = value }
    if let value = createdAt { dictionary[kUserInviteObjCreatedAtKey] = value }
    if let value = person { dictionary[kUserInviteObjPersonKey] = value }
    if let value = isFull { dictionary[kUserInviteObjIsFullKey] = value }
    if let value = createdBy { dictionary[kUserInviteObjCreatedByKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kUserInviteObjNameKey) as? String
    self.user = aDecoder.decodeObject(forKey: kUserInviteObjUserKey) as? User
    self.updatedAt = aDecoder.decodeObject(forKey: kUserInviteObjUpdatedAtKey) as? String
    self.address = aDecoder.decodeObject(forKey: kUserInviteObjAddressKey) as? String
    self.hrName = aDecoder.decodeObject(forKey: kUserInviteObjHrNameKey) as? String
    self.cid = aDecoder.decodeObject(forKey: kUserInviteObjCidKey) as? String
    self.lat = aDecoder.decodeObject(forKey: kUserInviteObjLatKey) as? Float
    self.price = aDecoder.decodeObject(forKey: kUserInviteObjPriceKey) as? Int
    self.uid = aDecoder.decodeObject(forKey: kUserInviteObjUidKey) as? String
    self.timeWork = aDecoder.decodeObject(forKey: kUserInviteObjTimeWorkKey) as? [TimeWork]
    self.content = aDecoder.decodeObject(forKey: kUserInviteObjContentKey) as? String
    self.status = aDecoder.decodeObject(forKey: kUserInviteObjStatusKey) as? Int
    self.hrPhone = aDecoder.decodeObject(forKey: kUserInviteObjHrPhoneKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kUserInviteObjInternalIdentifierKey) as? String
    self.lng = aDecoder.decodeObject(forKey: kUserInviteObjLngKey) as? Float
    self.updatedBy = aDecoder.decodeObject(forKey: kUserInviteObjUpdatedByKey) as? String
    self.inviteId = aDecoder.decodeObject(forKey: kUserInviteObjInviteIdKey) as? String
    self.createdAt = aDecoder.decodeObject(forKey: kUserInviteObjCreatedAtKey) as? String
    self.person = aDecoder.decodeObject(forKey: kUserInviteObjPersonKey) as? Int
    self.isFull = aDecoder.decodeObject(forKey: kUserInviteObjIsFullKey) as? Int
    self.createdBy = aDecoder.decodeObject(forKey: kUserInviteObjCreatedByKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kUserInviteObjNameKey)
    aCoder.encode(user, forKey: kUserInviteObjUserKey)
    aCoder.encode(updatedAt, forKey: kUserInviteObjUpdatedAtKey)
    aCoder.encode(address, forKey: kUserInviteObjAddressKey)
    aCoder.encode(hrName, forKey: kUserInviteObjHrNameKey)
    aCoder.encode(cid, forKey: kUserInviteObjCidKey)
    aCoder.encode(lat, forKey: kUserInviteObjLatKey)
    aCoder.encode(price, forKey: kUserInviteObjPriceKey)
    aCoder.encode(uid, forKey: kUserInviteObjUidKey)
    aCoder.encode(timeWork, forKey: kUserInviteObjTimeWorkKey)
    aCoder.encode(content, forKey: kUserInviteObjContentKey)
    aCoder.encode(status, forKey: kUserInviteObjStatusKey)
    aCoder.encode(hrPhone, forKey: kUserInviteObjHrPhoneKey)
    aCoder.encode(internalIdentifier, forKey: kUserInviteObjInternalIdentifierKey)
    aCoder.encode(lng, forKey: kUserInviteObjLngKey)
    aCoder.encode(updatedBy, forKey: kUserInviteObjUpdatedByKey)
    aCoder.encode(inviteId, forKey: kUserInviteObjInviteIdKey)
    aCoder.encode(createdAt, forKey: kUserInviteObjCreatedAtKey)
    aCoder.encode(person, forKey: kUserInviteObjPersonKey)
    aCoder.encode(isFull, forKey: kUserInviteObjIsFullKey)
    aCoder.encode(createdBy, forKey: kUserInviteObjCreatedByKey)
  }

}
