//
//  ReportObj.swift
//
//  Created by Quyet on 8/2/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ReportObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kReportObjPaymentKey: String = "payment"
  private let kReportObjPeopleKey: String = "people"
  private let kReportObjPercentSuccessKey: String = "percent_success"
    private let kReportObjRateKey: String = "rate"

  // MARK: Properties
  public var payment: String?
  public var people: Int?
  public var percentSuccess: String?
    public var rate: String?

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
    payment = json[kReportObjPaymentKey].string
    people = json[kReportObjPeopleKey].int
    percentSuccess = json[kReportObjPercentSuccessKey].string
    rate = json[kReportObjRateKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = payment { dictionary[kReportObjPaymentKey] = value }
    if let value = people { dictionary[kReportObjPeopleKey] = value }
    if let value = percentSuccess { dictionary[kReportObjPercentSuccessKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.payment = aDecoder.decodeObject(forKey: kReportObjPaymentKey) as? String
    self.people = aDecoder.decodeObject(forKey: kReportObjPeopleKey) as? Int
    self.percentSuccess = aDecoder.decodeObject(forKey: kReportObjPercentSuccessKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(payment, forKey: kReportObjPaymentKey)
    aCoder.encode(people, forKey: kReportObjPeopleKey)
    aCoder.encode(percentSuccess, forKey: kReportObjPercentSuccessKey)
  }

}
