//
//  RateHistoryObj.swift
//
//  Created by Quyet on 9/17/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class RateHistoryObj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kRateHistoryObjDescriptionValueKey: String = "description"
  private let kRateHistoryObjJobNameKey: String = "job_name"
  private let kRateHistoryObjInternalIdentifierKey: String = "id"
  private let kRateHistoryObjRateKey: String = "rate"

  // MARK: Properties
  public var descriptionValue: String?
  public var jobName: String?
  public var internalIdentifier: String?
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
    descriptionValue = json[kRateHistoryObjDescriptionValueKey].string
    jobName = json[kRateHistoryObjJobNameKey].string
    internalIdentifier = json[kRateHistoryObjInternalIdentifierKey].string
    rate = json[kRateHistoryObjRateKey].float
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = descriptionValue { dictionary[kRateHistoryObjDescriptionValueKey] = value }
    if let value = jobName { dictionary[kRateHistoryObjJobNameKey] = value }
    if let value = internalIdentifier { dictionary[kRateHistoryObjInternalIdentifierKey] = value }
    if let value = rate { dictionary[kRateHistoryObjRateKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.descriptionValue = aDecoder.decodeObject(forKey: kRateHistoryObjDescriptionValueKey) as? String
    self.jobName = aDecoder.decodeObject(forKey: kRateHistoryObjJobNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kRateHistoryObjInternalIdentifierKey) as? String
    self.rate = aDecoder.decodeObject(forKey: kRateHistoryObjRateKey) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(descriptionValue, forKey: kRateHistoryObjDescriptionValueKey)
    aCoder.encode(jobName, forKey: kRateHistoryObjJobNameKey)
    aCoder.encode(internalIdentifier, forKey: kRateHistoryObjInternalIdentifierKey)
    aCoder.encode(rate, forKey: kRateHistoryObjRateKey)
  }

}
