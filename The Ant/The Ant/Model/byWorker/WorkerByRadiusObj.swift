//
//  WorkerByRadiusObj.swift
//
//  Created by Quyet on 9/19/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class WorkerByRadiusObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kWorkerByRadiusObjLngKey: String = "lng"
  private let kWorkerByRadiusObjNameKey: String = "name"
  private let kWorkerByRadiusObjInternalIdentifierKey: String = "id"
  private let kWorkerByRadiusObjLatKey: String = "lat"
  private let kWorkerByRadiusObjRateKey: String = "rate"

  // MARK: Properties
  public var lng: Float?
  public var name: String?
  public var internalIdentifier: String?
  public var lat: Float?
  public var rate: Float?

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
    lng = json[kWorkerByRadiusObjLngKey].float
    name = json[kWorkerByRadiusObjNameKey].string
    internalIdentifier = json[kWorkerByRadiusObjInternalIdentifierKey].string
    lat = json[kWorkerByRadiusObjLatKey].float
    rate = json[kWorkerByRadiusObjRateKey].float
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = lng { dictionary[kWorkerByRadiusObjLngKey] = value }
    if let value = name { dictionary[kWorkerByRadiusObjNameKey] = value }
    if let value = internalIdentifier { dictionary[kWorkerByRadiusObjInternalIdentifierKey] = value }
    if let value = lat { dictionary[kWorkerByRadiusObjLatKey] = value }
    if let value = rate { dictionary[kWorkerByRadiusObjRateKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.lng = aDecoder.decodeObject(forKey: kWorkerByRadiusObjLngKey) as? Float
    self.name = aDecoder.decodeObject(forKey: kWorkerByRadiusObjNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kWorkerByRadiusObjInternalIdentifierKey) as? String
    self.lat = aDecoder.decodeObject(forKey: kWorkerByRadiusObjLatKey) as? Float
    self.rate = aDecoder.decodeObject(forKey: kWorkerByRadiusObjRateKey) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(lng, forKey: kWorkerByRadiusObjLngKey)
    aCoder.encode(name, forKey: kWorkerByRadiusObjNameKey)
    aCoder.encode(internalIdentifier, forKey: kWorkerByRadiusObjInternalIdentifierKey)
    aCoder.encode(lat, forKey: kWorkerByRadiusObjLatKey)
    aCoder.encode(rate, forKey: kWorkerByRadiusObjRateKey)
  }

}
