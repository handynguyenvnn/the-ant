//
//  User.swift
//
//  Created by Quyet on 7/11/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class User: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserNameKey: String = "name"
  private let kUserEmailKey: String = "email"
  private let kUserInternalIdentifierKey: String = "id"
  private let kUserAddressKey: String = "address"
  private let kUserPhoneKey: String = "phone"
  private let kUserAvatarKey: String = "avatar"
  private let kUserGenderKey: String = "gender"
  private let kUserTypeKey: String = "type"

  // MARK: Properties
  public var name: String?
  public var email: String?
  public var internalIdentifier: String?
  public var address: String?
  public var phone: String?
  public var avatar: String?
  public var gender: String?
  public var type: Int?

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
    name = json[kUserNameKey].string
    email = json[kUserEmailKey].string
    internalIdentifier = json[kUserInternalIdentifierKey].string
    address = json[kUserAddressKey].string
    phone = json[kUserPhoneKey].string
    avatar = json[kUserAvatarKey].string
    gender = json[kUserGenderKey].string
    type = json[kUserTypeKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kUserNameKey] = value }
    if let value = email { dictionary[kUserEmailKey] = value }
    if let value = internalIdentifier { dictionary[kUserInternalIdentifierKey] = value }
    if let value = address { dictionary[kUserAddressKey] = value }
    if let value = phone { dictionary[kUserPhoneKey] = value }
    if let value = avatar { dictionary[kUserAvatarKey] = value }
    if let value = gender { dictionary[kUserGenderKey] = value }
    if let value = type { dictionary[kUserTypeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kUserNameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kUserEmailKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kUserInternalIdentifierKey) as? String
    self.address = aDecoder.decodeObject(forKey: kUserAddressKey) as? String
    self.phone = aDecoder.decodeObject(forKey: kUserPhoneKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kUserAvatarKey) as? String
    self.gender = aDecoder.decodeObject(forKey: kUserGenderKey) as? String
    self.type = aDecoder.decodeObject(forKey: kUserTypeKey) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kUserNameKey)
    aCoder.encode(email, forKey: kUserEmailKey)
    aCoder.encode(internalIdentifier, forKey: kUserInternalIdentifierKey)
    aCoder.encode(address, forKey: kUserAddressKey)
    aCoder.encode(phone, forKey: kUserPhoneKey)
    aCoder.encode(avatar, forKey: kUserAvatarKey)
    aCoder.encode(gender, forKey: kUserGenderKey)
    aCoder.encode(type, forKey: kUserTypeKey)
  }

}
