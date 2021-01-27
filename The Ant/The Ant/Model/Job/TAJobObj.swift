//
//  TAJobObj.swift
//
//  Created by Tung Nguyen on 7/8/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
enum JOB_TRANGTHAI: Int {
    case InAcctive = 0
    case Acctive = 1
    
}
enum JOB_STATUS:Int {
    case NEW = 1
    case ENOUGH = 2
    case CANCEL = 3
    case FINISH = 4
    case NONE = -1
    
    func des() -> String {
        switch self {
        case .NEW:
            return "Mới"
        case .ENOUGH:
            return "Đủ"
        case .CANCEL:
            return "Hủy bỏ"
        case .FINISH:
            return "Hoàn thành"
            
        default:
            return ""
        }
    }
}
public class TAJobObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kDetailObjNameKey: String = "name"
    private let kDetailObjUserKey: String = "user"
    private let kDetailObjAddressKey: String = "address"
    private let kDetailObjCidKey: String = "cid"
    private let kDetailObjUserWorkersKey: String = "user_workers"
    private let kDetailObjPercentCompletedKey: String = "percent_completed"
    private let kDetailObjConditionKey: String = "condition"
    private let kDetailObjUidKey: String = "uid"
    private let kDetailObjTimeWorkKey: String = "time_work"
    private let kDetailObjContentKey: String = "content"
    private let kDetailObjPriceKey: String = "price"
    private let kDetailObjCategoryKey: String = "category"
    private let kDetailObjStatusKey: String = "status"
    private let kDetailObjInternalIdentifierKey: String = "id"
    private let kDetailObjPersonKey: String = "person"
    private let kProfileObjRealImagesKey: String = "real_images"
    private let kProfileObjstatusTextKey: String = "status_text"
    private let kProfileObjstatusTextColorKey: String = "status_text_color"
    private let kProfileObjstatusColorKey: String = "status_color"
    private let kMQUserObjImagesKey = "images"
    private let kMQUserObjtotalPriceKey = "total_price"
    private let kMQStoreObjLngKey: String = "lng"
    private let kMQStoreObjLatKey: String = "lat"
    private let kMQStoreObjpersonBidKey: String = "personBid"
    private let kMQStoreObjStatusKey: String = "status"
    private let kMQStoreObjhrNameKey: String = "hr_name"
    private let kMQStoreObjhrPhoneKey: String = "hr_phone"
    private let kMQStoreObjsubAddressKey: String = "sub_address"
    private let kMQStoreObjaddressComponentKey: String = "address_component"
    private let kMQStoreObjtotalHourKey: String = "total_hour"
    //private let kMQStoreObjtotalPriceKey: String = "total_price"
    
    
    
    // MARK: Properties
    //public var total_price: String?
    public var total_hour: String?
    public var name: String?
    public var user: User?
    public var address: String?
    public var cid: String?
    public var userWorkers: [UserWorkers]?
    public var percentCompleted: Int?
    public var condition: [ConditionObj]?
    public var uid: String?
    public var timeWork: [TimeWork]?
    var timeWorkData: [TimeWorkObj]?
    public var content: String?
    public var price: String?
    public var category: Category?
    public var status: Int?
    public var internalIdentifier: String?
    public var person: Int?
    public var realImages: [String]?
    public var status_text: String?
    public var status_text_color: String?
    public var status_color: String?
    public var total_price: Int64?
    var statusJob:STATUS_JOB?
    public var images :[ImageObj]?
    public var lng: Double?
    public var lat: Double?
    public var personBid: Int?
    var isExpand:Bool = false
    public var hr_name: String?
    public var hr_phone: String?
    public var sub_address: String?
    public var address_component: String?
    public var priceProgress:Int64?
    public var priceAll:Int64?
    public var isRate:Bool?
    public var rateObj:RateObj?
    //public var status: String?
    
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
        //status = json[kMQStoreObjStatusKey].string
        //total_price = json[kMQStoreObjtotalHourKey].string
        total_hour = json[kMQStoreObjtotalHourKey].string
        address_component = json[kMQStoreObjaddressComponentKey].string
        sub_address = json[kMQStoreObjsubAddressKey].string
        hr_name = json[kMQStoreObjhrNameKey].string
        hr_phone = json[kMQStoreObjhrPhoneKey].string
        personBid = json[kMQStoreObjpersonBidKey].int
        lng = json[kMQStoreObjLngKey].double
        lat = json[kMQStoreObjLatKey].double
        total_price = json[kMQUserObjtotalPriceKey].int64 ?? Int64(json[kMQUserObjtotalPriceKey].string ?? "")
        name = json[kDetailObjNameKey].string
        user = User(json: json[kDetailObjUserKey])
        address = json[kDetailObjAddressKey].string
        cid = json[kDetailObjCidKey].string
        if let items = json[kDetailObjUserWorkersKey].array { userWorkers = items.map { UserWorkers(json: $0) } }
        percentCompleted = json[kDetailObjPercentCompletedKey].int
        if let items = json[kDetailObjConditionKey].array { condition = items.map {ConditionObj(json: $0) }}
        uid = json[kDetailObjUidKey].string
        if let items = json[kDetailObjTimeWorkKey].array { timeWork = items.map { TimeWork(json: $0) } }
        content = json[kDetailObjContentKey].string
        price = json[kDetailObjPriceKey].string
        category = Category(json: json[kDetailObjCategoryKey])
        status = json[kDetailObjStatusKey].int
        statusJob = status.map { STATUS_JOB(rawValue: $0) } ?? STATUS_JOB.NONE
        //statusJob = status.map { STATUS_JOB(rawValue: "\($0)") } ?? STATUS_JOB.NONE
        internalIdentifier = json[kDetailObjInternalIdentifierKey].string
        status_text = json[kProfileObjstatusTextKey].string
        status_text_color = json[kProfileObjstatusTextColorKey].string
        status_color = json[kProfileObjstatusColorKey].string
        person = json[kDetailObjPersonKey].int
        if let items = json[kProfileObjRealImagesKey].array { realImages = items.map { $0.stringValue } }
        if let items = json[kMQUserObjImagesKey].array { images = items.map { ImageObj(json: $0) } }
        priceProgress = json["priceProgress"].int64
        priceAll = json["priceAll"].int64
        isRate = json["is_rate"].bool
        rateObj = RateObj.init(object:json["rate"])
        
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[kDetailObjNameKey] = value }
        if let value = user { dictionary[kDetailObjUserKey] = value.dictionaryRepresentation() }
        if let value = address { dictionary[kDetailObjAddressKey] = value }
        if let value = cid { dictionary[kDetailObjCidKey] = value }
        if let value = userWorkers { dictionary[kDetailObjUserWorkersKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = percentCompleted { dictionary[kDetailObjPercentCompletedKey] = value }
        if let value = condition { dictionary[kDetailObjConditionKey] = value }
        if let value = uid { dictionary[kDetailObjUidKey] = value }
        if let value = timeWork { dictionary[kDetailObjTimeWorkKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = content { dictionary[kDetailObjContentKey] = value }
        if let value = price { dictionary[kDetailObjPriceKey] = value }
        if let value = category { dictionary[kDetailObjCategoryKey] = value.dictionaryRepresentation() }
        if let value = status { dictionary[kDetailObjStatusKey] = value }
        if let value = internalIdentifier { dictionary[kDetailObjInternalIdentifierKey] = value }
        if let value = status_text { dictionary[kProfileObjstatusTextKey] = value }
        if let value = person { dictionary[kDetailObjPersonKey] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: kDetailObjNameKey) as? String
        self.user = aDecoder.decodeObject(forKey: kDetailObjUserKey) as? User
        self.address = aDecoder.decodeObject(forKey: kDetailObjAddressKey) as? String
        self.cid = aDecoder.decodeObject(forKey: kDetailObjCidKey) as? String
        self.userWorkers = aDecoder.decodeObject(forKey: kDetailObjUserWorkersKey) as? [UserWorkers]
        self.percentCompleted = aDecoder.decodeObject(forKey: kDetailObjPercentCompletedKey) as? Int
        self.condition = aDecoder.decodeObject(forKey: kDetailObjConditionKey) as? [ConditionObj]
        self.uid = aDecoder.decodeObject(forKey: kDetailObjUidKey) as? String
        self.timeWork = aDecoder.decodeObject(forKey: kDetailObjTimeWorkKey) as? [TimeWork]
        self.content = aDecoder.decodeObject(forKey: kDetailObjContentKey) as? String
        self.price = aDecoder.decodeObject(forKey: kDetailObjPriceKey) as? String
        self.category = aDecoder.decodeObject(forKey: kDetailObjCategoryKey) as? Category
        self.status = aDecoder.decodeObject(forKey: kDetailObjStatusKey) as? Int
        self.internalIdentifier = aDecoder.decodeObject(forKey: kDetailObjInternalIdentifierKey) as? String
        self.person = aDecoder.decodeObject(forKey: kDetailObjPersonKey) as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: kDetailObjNameKey)
        aCoder.encode(user, forKey: kDetailObjUserKey)
        aCoder.encode(address, forKey: kDetailObjAddressKey)
        aCoder.encode(cid, forKey: kDetailObjCidKey)
        aCoder.encode(userWorkers, forKey: kDetailObjUserWorkersKey)
        aCoder.encode(percentCompleted, forKey: kDetailObjPercentCompletedKey)
        aCoder.encode(condition, forKey: kDetailObjConditionKey)
        aCoder.encode(uid, forKey: kDetailObjUidKey)
        aCoder.encode(timeWork, forKey: kDetailObjTimeWorkKey)
        aCoder.encode(content, forKey: kDetailObjContentKey)
        aCoder.encode(price, forKey: kDetailObjPriceKey)
        aCoder.encode(category, forKey: kDetailObjCategoryKey)
        aCoder.encode(status, forKey: kDetailObjStatusKey)
        aCoder.encode(internalIdentifier, forKey: kDetailObjInternalIdentifierKey)
        aCoder.encode(person, forKey: kDetailObjPersonKey)
    }
    public func toStringAddJson() -> String {
        let stringJson = "\(address ?? "")"
        //let json = JSON.init(parseJSON: stringJson)
        return stringJson
    }
    public func toStringLatJson() -> String {
        //let stringJson = "{\"addr\":\"\(address ?? "")\",\"lat\":\(lat ?? 0.0),\"long\":\(lng ?? 0.0)}"
        let stringJson = "\(lat ?? 0)"
        //let json = JSON.init(parseJSON: stringJson)
        return stringJson
    }
    public func toStringLngJson() -> String {
        //let stringJson = "{\"addr\":\"\(address ?? "")\",\"lat\":\(lat ?? 0.0),\"long\":\(lng ?? 0.0)}"
        let stringJson = "\(lng ?? 0)"
        //let json = JSON.init(parseJSON: stringJson)
        return stringJson
    }

}
