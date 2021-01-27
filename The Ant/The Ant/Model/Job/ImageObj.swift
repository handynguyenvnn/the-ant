//
//  ImageObj.swift
//
//  Created by Quyet on 7/9/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ImageObj: NSObject,NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kImageObjSrcKey: String = "src"
  private let kImageObjLinkKey: String = "link"
  private let kImageObjThumbKey: String = "thumb"
  private let kImageObjNameKey: String = "name"
  private let kImageObjInternalIdentifierKey: String = "id"
  private let kImageObjExtKey: String = "ext"
  private let kImageObjWidthKey: String = "width"
  private let kImageObjHeighKey: String = "heigh"
  private let kImageObjCaptionKey: String = "caption"

  // MARK: Properties
  public var src: String?
  public var link: String?
  public var thumb: String?
  public var name: String?
  public var internalIdentifier: String?
  public var ext: String?
  public var width: Int?
  public var heigh: Int?
  public var caption: String?
    var image:UIImage?
    var isOldImage:Bool = false

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
    src = json[kImageObjSrcKey].string
    link = json[kImageObjLinkKey].string
    thumb = json[kImageObjThumbKey].string
    name = json[kImageObjNameKey].string
    internalIdentifier = json[kImageObjInternalIdentifierKey].string
    ext = json[kImageObjExtKey].string
    width = json[kImageObjWidthKey].int
    heigh = json[kImageObjHeighKey].int
    caption = json[kImageObjCaptionKey].string
    if link != nil{
        loadImage()
    }else if thumb != nil{
        loadImageEdit()
    }
    
  }
    func loadImage(){
        UIImageView().sd_setHighlightedImage(with: URL.init(string: link ?? ""), options: .refreshCached) { (img, err, type, url) in
            self.image = img
        }
    }
    func loadImageEdit(){
        UIImageView().sd_setHighlightedImage(with: URL.init(string: thumb ?? ""), options: .refreshCached) { (img, err, type, url) in
            self.image = img
        }
    }
    init(url:String) {
        super.init()
        UIImageView().sd_setHighlightedImage(with: URL.init(string: url), options: .refreshCached) { (img, err, type, url) in
            self.image = img
        }
    }
    init(url:ImageObj,idImg :String? = nil){
        super.init()
        self.internalIdentifier = url.internalIdentifier
        UIImageView().sd_setHighlightedImage(with: URL.init(string: url.thumb ?? ""), options: .refreshCached, progress: nil){ (img, err, type, url) in
            self.image = img
        }
    }
  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = src { dictionary[kImageObjSrcKey] = value }
    if let value = link { dictionary[kImageObjLinkKey] = value }
    if let value = thumb { dictionary[kImageObjThumbKey] = value }
    if let value = name { dictionary[kImageObjNameKey] = value }
    if let value = internalIdentifier { dictionary[kImageObjInternalIdentifierKey] = value }
    if let value = ext { dictionary[kImageObjExtKey] = value }
    if let value = width { dictionary[kImageObjWidthKey] = value }
    if let value = heigh { dictionary[kImageObjHeighKey] = value }
    if let value = caption { dictionary[kImageObjCaptionKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.src = aDecoder.decodeObject(forKey: kImageObjSrcKey) as? String
    self.link = aDecoder.decodeObject(forKey: kImageObjLinkKey) as? String
    self.thumb = aDecoder.decodeObject(forKey: kImageObjThumbKey) as? String
    self.name = aDecoder.decodeObject(forKey: kImageObjNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kImageObjInternalIdentifierKey) as? String
    self.ext = aDecoder.decodeObject(forKey: kImageObjExtKey) as? String
    self.width = aDecoder.decodeObject(forKey: kImageObjWidthKey) as? Int
    self.heigh = aDecoder.decodeObject(forKey: kImageObjHeighKey) as? Int
    self.caption = aDecoder.decodeObject(forKey: kImageObjCaptionKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(src, forKey: kImageObjSrcKey)
    aCoder.encode(link, forKey: kImageObjLinkKey)
    aCoder.encode(thumb, forKey: kImageObjThumbKey)
    aCoder.encode(name, forKey: kImageObjNameKey)
    aCoder.encode(internalIdentifier, forKey: kImageObjInternalIdentifierKey)
    aCoder.encode(ext, forKey: kImageObjExtKey)
    aCoder.encode(width, forKey: kImageObjWidthKey)
    aCoder.encode(heigh, forKey: kImageObjHeighKey)
    aCoder.encode(caption, forKey: kImageObjCaptionKey)
  }

}
