//
//  MQUserObj.swift
//
//  Created by Tung Nguyen on 6/14/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainSwift
enum CUSTOMTYPE : Int{
    case GROUP = 0
    case PRESON = 1
    case CANCEL = 2
    case NONE = -1
    func des() -> String {
        switch self {
        case .GROUP:
            return "Doanh nghiệp"
        case .PRESON:
            return "Cá nhân"
        case .CANCEL:
            return "Tổ chức"
        default:
            return ""
        }
    }
}

public class UserObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMQUserObjTotalPointKey: String = "total_point"
  private let kMQUserObjNameKey: String = "name"
  private let kMQUserObjEmailKey: String = "email"
  private let kMQUserObjAddressKey: String = "address"
  private let kMQUserObjSocialTextKey: String = "social_text"
  private let kMQUserObjLevelKey: String = "level"
  private let kMQUserObjSocialIdKey: String = "social_id"
  private let kMQUserObjStatusKey: String = "status"
  private let kMQUserObjInternalIdentifierKey: String = "id"
  private let kMQUserObjCodeKey: String = "code"
  private let kMQUserObjLevelTextKey: String = "level_text"
  private let kMQUserObjPhoneKey: String = "phone"
  private let kMQUserObjAvatarKey: String = "avatar"
  private let kMQUserObjisFirstLoginKey = "first_login"
    private let kMQUserObjStatisticKey = "data_statistic"
    private let kMQUserObjUserKey = "data_user"
    private let kProfileObjCategoryKey: String = "category"
    private let kProfileObjRealImagesKey: String = "real_images"
    private let kProfileObjBirthdayKey: String = "birthday"
    private let kMQUserObjImagesKey = "real_images"
    private let kMQUserObjisOnline = "online"
    private let kProfileObjAccountKey: String = "account"
    private let kDescription: String = "description"
    private let kPrice: String = "price"
    private let CategoryTmpKey = "category_tmp"
    private let kMQStoreObjLngKey: String = "lng"
    private let kMQStoreObjLatKey: String = "lat"
    private let kMQStoreObjHotlineKey: String = "hotline"
    private let kMQStoreObjsubTypeKey: String = "sub_type"
    //private let kMQUserObjCodeKey: String = "code"
    //private let kProfileObjCategoryKey: String = "category"
    private let bankName = "bank_name"
    private let accountName = "account_name"
    private let accountNumber = "account_number"
    private let branchName = "branch_name"
    private let bankCode = "bank_code"
    private let bankShortName = "bank_short_name"
    private let bankId = "bank_id"
    private let keytotal = "total"
    private let keyjob_invite =  "job_invite"
    private let keySummary =  "summary"
    private let CateFavTmpKey = "cate_fav"
  // MARK: Properties
    //public var code: String?
    public var summary: String?
    public var sub_type: Int?
    public var bank_id: String?
    public var bank_name: String?
    public var account_name: String?
    public var account_number: String?
    public var branch_name: String?
    public var bank_code: String?
    public var bank_short_name: String?
    public var hotline: String?
  public var totalPoint: Int?
  public var name: String?
  public var email: String?
  public var address: String?
  public var socialText: String?
    public var cate_fav: [CateObj]?
  public var level: Int?
  public var socialId: String?
  public var status: Int?
  public var internalIdentifier: String?
  public var code: String?
  public var levelText: String?
  public var phone: String?
  public var avatar: String?
  public var isFirstLogin : Bool?
    public var categoryProfile: [CategoryProfile]?
    public var rate:Float?
    public var realImages: [String]?
    public var birthday: String?
    public var images :[ImageObj]?
    public var isOnline: Int?
    public var account: String?
    public var desc:String?
    public var category_tmp:[CateObj]?
    public var categoryMe: [CateObj]?
    public var price:String?
    public var lng: Float?
    public var lat: Float?
public var totalJobInvite: Int?
    var subType:GENDER = .NONE
    var subTypeCus:CUSTOMTYPE = .NONE
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
//    let jsonUser = JSON.init(json[kMQUserObjUserKey])
    
    sub_type = json[kMQStoreObjsubTypeKey].int ?? Int(json[kMQStoreObjsubTypeKey].string ?? "")
    subType = GENDER(rawValue: sub_type ?? -1) ?? .NONE
    subTypeCus = CUSTOMTYPE(rawValue: sub_type ?? -1) ?? .NONE
    bank_id = json[bankId].string
    hotline = json[kMQStoreObjHotlineKey].string
    lng = json[kMQStoreObjLngKey].float
    lat = json[kMQStoreObjLatKey].float
    if let items = json[kProfileObjCategoryKey].array { categoryMe = items.map { CateObj(json: $0) } }
    code = json[kMQUserObjCodeKey].string
    price = json[kPrice].string
    birthday = json[kProfileObjBirthdayKey].string
    isOnline = json[kMQUserObjisOnline].int
    totalPoint = json[kMQUserObjTotalPointKey].int
    name = json[kMQUserObjNameKey].string
    email = json[kMQUserObjEmailKey].string
    address = json[kMQUserObjAddressKey].string
    socialText = json[kMQUserObjSocialTextKey].string
    level = json[kMQUserObjLevelKey].int
    socialId = json[kMQUserObjSocialIdKey].string
    status = json[kMQUserObjStatusKey].int
    internalIdentifier = json[kMQUserObjInternalIdentifierKey].string
    code = json[kMQUserObjCodeKey].string
    levelText = json[kMQUserObjLevelTextKey].string
    phone = json[kMQUserObjPhoneKey].string
    avatar = json[kMQUserObjAvatarKey].string
    account = json[kProfileObjAccountKey].string
    isFirstLogin = json[kMQUserObjisFirstLoginKey].bool
    if let items = json[CateFavTmpKey].array { cate_fav = items.map { CateObj(json: $0) } }
    if let items = json[kProfileObjCategoryKey].array { categoryProfile = items.map { CategoryProfile(json: $0) } }
    rate = json["rate"].float
    if let items = json[CategoryTmpKey].array { category_tmp = items.map { CateObj(json: $0) } }
    if let items = json[kProfileObjRealImagesKey].array { realImages = items.map { $0.stringValue } }
    if let items = json[kMQUserObjImagesKey].array { images = items.map { ImageObj(json: $0) } }
    desc = json[kDescription].string
    bank_name = json[bankName].string
    account_name = json[accountName].string
    account_number = json[accountNumber].string
    branch_name = json[branchName].string
    bank_code = json[bankCode].string
    bank_short_name = json[bankShortName].string
    totalJobInvite = json[keyjob_invite][keytotal].int ?? Int(json[keyjob_invite][keytotal].string ?? "")
    summary = json[keySummary].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = totalPoint { dictionary[kMQUserObjTotalPointKey] = value }
    if let value = name { dictionary[kMQUserObjNameKey] = value }
    if let value = email { dictionary[kMQUserObjEmailKey] = value }
    if let value = address { dictionary[kMQUserObjAddressKey] = value }
    if let value = socialText { dictionary[kMQUserObjSocialTextKey] = value }
    if let value = level { dictionary[kMQUserObjLevelKey] = value }
    if let value = socialId { dictionary[kMQUserObjSocialIdKey] = value }
    if let value = status { dictionary[kMQUserObjStatusKey] = value }
    if let value = internalIdentifier { dictionary[kMQUserObjInternalIdentifierKey] = value }
    if let value = code { dictionary[kMQUserObjCodeKey] = value }
    if let value = levelText { dictionary[kMQUserObjLevelTextKey] = value }
    if let value = phone { dictionary[kMQUserObjPhoneKey] = value }
    if let value = avatar { dictionary[kMQUserObjAvatarKey] = value }
    if let value = isFirstLogin { dictionary[kMQUserObjisFirstLoginKey] = value }
    if let value = categoryProfile { dictionary[kProfileObjCategoryKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = realImages { dictionary[kProfileObjRealImagesKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.totalPoint = aDecoder.decodeObject(forKey: kMQUserObjTotalPointKey) as? Int
    self.name = aDecoder.decodeObject(forKey: kMQUserObjNameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kMQUserObjEmailKey) as? String
    self.address = aDecoder.decodeObject(forKey: kMQUserObjAddressKey) as? String
    self.socialText = aDecoder.decodeObject(forKey: kMQUserObjSocialTextKey) as? String
    self.level = aDecoder.decodeObject(forKey: kMQUserObjLevelKey) as? Int
    self.socialId = aDecoder.decodeObject(forKey: kMQUserObjSocialIdKey) as? String
    self.status = aDecoder.decodeObject(forKey: kMQUserObjStatusKey) as? Int
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMQUserObjInternalIdentifierKey) as? String
    self.code = aDecoder.decodeObject(forKey: kMQUserObjCodeKey) as? String
    self.levelText = aDecoder.decodeObject(forKey: kMQUserObjLevelTextKey) as? String
    self.phone = aDecoder.decodeObject(forKey: kMQUserObjPhoneKey) as? String
    self.avatar = aDecoder.decodeObject(forKey: kMQUserObjAvatarKey) as? String
    self.isFirstLogin = aDecoder.decodeObject(forKey: kMQUserObjisFirstLoginKey) as? Bool
    self.rate = aDecoder.decodeObject(forKey: "rate") as? Float
    
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(totalPoint, forKey: kMQUserObjTotalPointKey)
    aCoder.encode(name, forKey: kMQUserObjNameKey)
    aCoder.encode(email, forKey: kMQUserObjEmailKey)
    aCoder.encode(address, forKey: kMQUserObjAddressKey)
    aCoder.encode(socialText, forKey: kMQUserObjSocialTextKey)
    aCoder.encode(level, forKey: kMQUserObjLevelKey)
    aCoder.encode(socialId, forKey: kMQUserObjSocialIdKey)
    aCoder.encode(status, forKey: kMQUserObjStatusKey)
    aCoder.encode(internalIdentifier, forKey: kMQUserObjInternalIdentifierKey)
    aCoder.encode(code, forKey: kMQUserObjCodeKey)
    aCoder.encode(levelText, forKey: kMQUserObjLevelTextKey)
    aCoder.encode(phone, forKey: kMQUserObjPhoneKey)
    aCoder.encode(avatar, forKey: kMQUserObjAvatarKey)
    aCoder.encode(isFirstLogin, forKey: kMQUserObjisFirstLoginKey)
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
    class func getUserName()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("username") ?? ""
    }
    class func saveGGId(userCode:String?)
    {
        if userCode != nil
        {
            let keychain = KeychainSwift()
            keychain.set(userCode!, forKey: "gg_id")
        }
        
    }
    class func getGGId()->String
    {
        let keychain = KeychainSwift()
        return keychain.get("gg_id") ?? ""
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
