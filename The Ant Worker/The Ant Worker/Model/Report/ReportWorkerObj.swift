//
//  ReportWorkerObj.swift
//
//  Created by Tung Nguyen on 8/7/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ReportWorkerObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kReportWorkerObjIconKey: String = "icon"
  private let kReportWorkerObjTitleKey: String = "title"
  private let kReportWorkerObjValueKey: String = "value"

  // MARK: Properties
  public var icon: String?
  public var title: String?
  public var value: String?

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
    icon = json[kReportWorkerObjIconKey].string
    title = json[kReportWorkerObjTitleKey].string
    value = json[kReportWorkerObjValueKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = icon { dictionary[kReportWorkerObjIconKey] = value }
    if let value = title { dictionary[kReportWorkerObjTitleKey] = value }
    if let value = value { dictionary[kReportWorkerObjValueKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.icon = aDecoder.decodeObject(forKey: kReportWorkerObjIconKey) as? String
    self.title = aDecoder.decodeObject(forKey: kReportWorkerObjTitleKey) as? String
    self.value = aDecoder.decodeObject(forKey: kReportWorkerObjValueKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(icon, forKey: kReportWorkerObjIconKey)
    aCoder.encode(title, forKey: kReportWorkerObjTitleKey)
    aCoder.encode(value, forKey: kReportWorkerObjValueKey)
  }

}
