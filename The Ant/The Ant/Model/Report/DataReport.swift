//
//  DataReport.swift
//
//  Created by Quyet on 8/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class DataReport: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kDataReportPaymentKey: String = "payment"
  private let kDataReportPeopleKey: String = "people"
  private let kDataReportRateKey: String = "rate"
  private let kDataReportPercentSuccessKey: String = "percent_success"

  // MARK: Properties
  public var payment: Payment?
  public var people: People?
  public var rate: Rate?
  public var percentSuccess: PercentSuccess?

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
    payment = Payment(json: json[kDataReportPaymentKey])
    people = People(json: json[kDataReportPeopleKey])
    rate = Rate(json: json[kDataReportRateKey])
    percentSuccess = PercentSuccess(json: json[kDataReportPercentSuccessKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = payment { dictionary[kDataReportPaymentKey] = value.dictionaryRepresentation() }
    if let value = people { dictionary[kDataReportPeopleKey] = value.dictionaryRepresentation() }
    if let value = rate { dictionary[kDataReportRateKey] = value.dictionaryRepresentation() }
    if let value = percentSuccess { dictionary[kDataReportPercentSuccessKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.payment = aDecoder.decodeObject(forKey: kDataReportPaymentKey) as? Payment
    self.people = aDecoder.decodeObject(forKey: kDataReportPeopleKey) as? People
    self.rate = aDecoder.decodeObject(forKey: kDataReportRateKey) as? Rate
    self.percentSuccess = aDecoder.decodeObject(forKey: kDataReportPercentSuccessKey) as? PercentSuccess
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(payment, forKey: kDataReportPaymentKey)
    aCoder.encode(people, forKey: kDataReportPeopleKey)
    aCoder.encode(rate, forKey: kDataReportRateKey)
    aCoder.encode(percentSuccess, forKey: kDataReportPercentSuccessKey)
  }

}
