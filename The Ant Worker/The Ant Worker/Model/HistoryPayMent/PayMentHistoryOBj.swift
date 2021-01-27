//
//  PayMentHistoryOBj.swift
//
//  Created by Quyet on 10/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class PayMentHistoryOBj: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPayMentHistoryOBjStatusKey: String = "status"
  private let kPayMentHistoryOBjPriceKey: String = "price"
private let kPayMentHistoryOBjDateKey: String = "date"
    private let kPayMentHistoryOBjCodeKey: String = "code"
    private let kPayMentHistoryOBjTitleKey: String = "title"
    private let kPayMentHistoryOBjstatusTextKey: String = "status_text"
    private let kPayMentHistoryOBjColorKey: String = "color"
    private let kPayMentHistoryOBjBackgroundKey: String = "background"

  // MARK: Properties
  public var status: Int?
  public var price: String?
    public var date: String?
    public var code: String?
    public var title: String?
    public var status_text: String?
    public var color: String?
    public var background: String?

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
    color = json[kPayMentHistoryOBjColorKey].string
    background = json[kPayMentHistoryOBjBackgroundKey].string
    status_text = json[kPayMentHistoryOBjstatusTextKey].string
    title = json[kPayMentHistoryOBjTitleKey].string
    code = json[kPayMentHistoryOBjCodeKey].string
    status = json[kPayMentHistoryOBjStatusKey].int
    price = json[kPayMentHistoryOBjPriceKey].string
    date = json[kPayMentHistoryOBjDateKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kPayMentHistoryOBjStatusKey] = value }
    if let value = price { dictionary[kPayMentHistoryOBjPriceKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kPayMentHistoryOBjStatusKey) as? Int
    self.price = aDecoder.decodeObject(forKey: kPayMentHistoryOBjPriceKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kPayMentHistoryOBjStatusKey)
    aCoder.encode(price, forKey: kPayMentHistoryOBjPriceKey)
  }

}
