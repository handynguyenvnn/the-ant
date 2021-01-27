//
//  MQUserObj.swift
//
//  Created by Tung Nguyen on 6/14/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainSwift


public class UserObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
 
  private let kMQUserObjNameKey: String = "name"
  private let kMQUserObjEmailKey: String = "email"
  private let kMQUserObjAddressKey: String = "address"
  private let kMQUserObjStatusKey: String = "status"
  private let kMQUserObjInternalIdentifierKey: String = "id"
  private let kMQUserObjPhoneKey: String = "phone"
  private let kMQUserObjAvatarKey: String = "avatar"
  private let TypeKey = "type"
  private let GenderKey = "gender"
  private let PasswordKey = "password"
  private let BirthdayKey = "birthday"
  private let Updated_atKey = "updated_at"
  private let Created_atKey = "created_at"
  private let CategoryKey = "category"
private let kProfileObjCategoryKey: String = "category"
    private let kMQStoreObjHotlineKey: String = "hotline"
    private let kProfileObjRealImagesKey: String = "real_images"
    private let kProfileObjAccountKey: String = "account"
    private let kMQUserObjisFirstLoginKey = "first_login"
    private let kMQUserObjImagesKey = "real_images"
    private let kMQUserObjDescriptionKey = "description"
    private let CategoryTmpKey = "category_tmp"
    private let CateFavTmpKey = "cate_fav"
    private let PriceKey = "price"
    private let DescriptionKey = "description"
    private let Rate = "rate"
    private let bankName = "bank_name"
    private let accountName = "account_name"
    private let accountNumber = "account_number"
    private let branchName = "branch_name"
    private let bankCode = "bank_code"
    private let bankShortName = "bank_short_name"
    private let kMQUserObjsubTypeKey = "sub_type"
    private let keySummary =  "summary"
    private let kMQUserObjCodeKey: String = "code"

  // MARK: Properties
    public var code: String?
    public var hotline: String?
    public var sub_type: Int?
    public var bank_name: String?
    public var account_name: String?
    public var account_number: String?
    public var branch_name: String?
    public var bank_code: String?
    public var bank_short_name: String?
    public var images :[ImageObj]?
  public var name: String?
  public var email: String?
  public var address: String?
  public var status: Int?
  public var internalIdentifier: String?
  public var phone: String?
  public var avatar: String?
  public var type: Int?
  public var gender: String?
  public var password: String?
  public var birthday: String?
    public var desc: String?
    public var account: String?
    public var updated_at: String?
    public var created_at: String?
    public var category: String?
    public var rate:Float?
    public var category_tmp:[CateObj]?
    public var categoryMe: [CateObj]?
    public var cate_fav: [CateObj]?
    public var realImages: [String]?
    public var isFirstLogin : Int? = 1
    public var price :String?
    public var decs:String?
    public var rateStar:String?
    var subType:CUSTOMTYPE = .NONE
    var subGENDER:GENDER = .NONE
    public var summary: String?
    
    //public var images: [ImageObj]?
    
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
    super.init()
    //let jsonUser = JSON.init(json[kMQUserObjUserKey])
    if let items = json[CateFavTmpKey].array { cate_fav = items.map { CateObj(json: $0) } }
    if let items = json[kProfileObjCategoryKey].array { categoryMe = items.map { CateObj(json: $0) } }
    if let items = json[kMQUserObjImagesKey].array { images = items.map { ImageObj(json: $0) } }
    for img in images ?? [ImageObj](){
        img.isOldImage = true
    }
    code = json[kMQUserObjCodeKey].string
    hotline = json[kMQStoreObjHotlineKey].string
    sub_type = json[kMQUserObjsubTypeKey].int ?? Int(json[kMQUserObjsubTypeKey].string ?? "")
    subType = CUSTOMTYPE(rawValue: sub_type ?? -1) ?? .NONE
    subGENDER = GENDER(rawValue: sub_type ?? -1) ?? .NONE
    rateStar = json[Rate].string
    decs = json[DescriptionKey].string
    price = json[PriceKey].string
    desc = json[kMQUserObjDescriptionKey].string
    name = json[kMQUserObjNameKey].string
    email = json[kMQUserObjEmailKey].string
    address = json[kMQUserObjAddressKey].string
    status = json[kMQUserObjStatusKey].int
    internalIdentifier = json[kMQUserObjInternalIdentifierKey].string
    phone = json[kMQUserObjPhoneKey].string
    avatar = json[kMQUserObjAvatarKey].string
    type = json[TypeKey].int
    gender = json[GenderKey].string
    password = json[PasswordKey].string
    birthday = json[BirthdayKey].string
    updated_at = json[Updated_atKey].string
    created_at = json[Created_atKey].string
    category = json[CategoryKey].string
    account = json[kProfileObjAccountKey].string
    rate = json["rate"].float
    if let items = json[CategoryTmpKey].array { category_tmp = items.map { CateObj(json: $0) } }
    //isFirstLogin = json[kMQUserObjisFirstLoginKey].bool
    if let items = json[kProfileObjRealImagesKey].array { realImages = items.map { $0.stringValue } }
    bank_name = json[bankName].string
    account_name = json[accountName].string
    account_number = json[accountNumber].string
    branch_name = json[branchName].string
    bank_code = json[bankCode].string
    bank_short_name = json[bankShortName].string
    summary = json[keySummary].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = categoryMe { dictionary[kProfileObjCategoryKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = name { dictionary[kMQUserObjNameKey] = value }
    if let value = email { dictionary[kMQUserObjEmailKey] = value }
    if let value = address { dictionary[kMQUserObjAddressKey] = value }
    if let value = status { dictionary[kMQUserObjStatusKey] = value }
    if let value = internalIdentifier { dictionary[kMQUserObjInternalIdentifierKey] = value }
    if let value = phone { dictionary[kMQUserObjPhoneKey] = value }
    if let value = avatar { dictionary[kMQUserObjAvatarKey] = value }
    if let value = realImages { dictionary[kProfileObjRealImagesKey] = value }
    if let value = account { dictionary[kProfileObjRealImagesKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.categoryMe = aDecoder.decodeObject(forKey: kProfileObjCategoryKey) as? [CateObj]
    self.name = aDecoder.decodeObject(forKey: kMQUserObjNameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kMQUserObjEmailKey) as? String
    self.address = aDecoder.decodeObject(forKey: kMQUserObjAddressKey) as? String
    self.status = aDecoder.decodeObject(forKey: kMQUserObjStatusKey) as? Int
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMQUserObjInternalIdentifierKey) as? String
    self.phone = aDecoder.decodeObject(forKey: kMQUserObjPhoneKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kMQUserObjAvatarKey) as? String
    self.rate = aDecoder.decodeObject(forKey: "rate") as? Float
    self.account = aDecoder.decodeObject(forKey: kProfileObjAccountKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
  
    aCoder.encode(name, forKey: kMQUserObjNameKey)
    aCoder.encode(email, forKey: kMQUserObjEmailKey)
    aCoder.encode(address, forKey: kMQUserObjAddressKey)
    aCoder.encode(status, forKey: kMQUserObjStatusKey)
    aCoder.encode(internalIdentifier, forKey: kMQUserObjInternalIdentifierKey)
    aCoder.encode(phone, forKey: kMQUserObjPhoneKey)
    aCoder.encode(avatar, forKey: kMQUserObjAvatarKey)
    aCoder.encode(account, forKey: kProfileObjAccountKey)
    aCoder.encode(rate, forKey: "rate")
  }
    class func saveUserName(username:String?)
    {
        if username != nil
        {
            let keychain = KeychainSwift()
            keychain.set(username!, forKey: "username")
        }
        
    }
    class func getGGId()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("gg_id") ?? ""
    }
    class func getUserName()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("username") ?? ""
    }
    class func saveUserCode(userCode:String?)
    {
        if userCode != nil
        {
            let keychain = KeychainSwift()
            keychain.set(userCode!, forKey: "userCode")
        }
        
    }
    class func saveGGId(userCode:String?)
    {
        if userCode != nil
        {
            let keychain = KeychainSwift()
            keychain.set(userCode!, forKey: "gg_id")
        }
        
    }
    class func getUserCode()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("userCode") ?? ""
    }
    class func saveFbCode(fbCode:String?)
    {
        if fbCode != nil
        {
            let keychain = KeychainSwift()
            keychain.set(fbCode!, forKey: "fbCode")
        }
        
    }
    class func getFbCode()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("fbCode") ?? ""
    }
    class func removeDataUser()
    {
        let keychain = KeychainSwift()
        keychain.delete("password")
        if !UserDefaults.resultRememberLogin() {
            keychain.delete("username")
            UserDefaults.standard.removeObject(forKey: "save_user_obj")
        }
        //NEED_FIX remove badge
        UserDefaults.standard.removeObject(forKey: "TOKEN")
    }
    class func savePassWord(password:String?)
    {
        if password != nil
        {
            let keychain = KeychainSwift()
            keychain.set(password!, forKey: "password")
        }
        
    }
    class func getPassWord()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("password") ?? ""
    }

}
