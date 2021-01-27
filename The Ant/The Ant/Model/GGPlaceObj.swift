//
//  GGPlaceObj.swift
//
//  Created by Khiem on 2018-09-15
//  Copyright (c) SuSoft. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class GGPlaceObj: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let lat = "lat"
    static let addr = "addr"
    static let long = "long"
    //static let adress = "adress"
  }

  // MARK: Properties
  public var lat: Double?
  public var addr: String?
  public var long: Double?
  public var placeId: String?
    
    public var adressComponent:JSON?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }
    public override init(){
        
    }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    //adress = json[SerializationKeys.adress].string ?? <#default value#>
    lat = json[SerializationKeys.lat].double ?? Double(json[SerializationKeys.lat].string ?? "")
    addr = json[SerializationKeys.addr].string
    long = json[SerializationKeys.long].double ?? Double(json[SerializationKeys.long].string ?? "")
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = addr { dictionary[SerializationKeys.addr] = value }
    if let value = long { dictionary[SerializationKeys.long] = value }
    return dictionary
  }
  //let stringJson = "{\"addr\":\"\(addr ?? "")\",\"lat\":\(lat ?? 0.0),\"long\":\(long ?? 0.0)}"
    public func toStringJson() -> String {
        let stringJson = "\(addr ?? "")"
        //let stringJson = "{\"addr\":\"\(addr ?? "")\",\"lat\":\(lat ?? 0.0),\"long\":\(long ?? 0.0)}"
        //let json = JSON.init(parseJSON: stringJson)
        return stringJson
    }
  

}
