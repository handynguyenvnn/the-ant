//
//  WHImagePlaceAnnotation.swift
//  whh
//
//  Created by MAC on 12/14/16.
//  Copyright © 2016 Hoang Mai Long. All rights reserved.
//

import MapKit
class ImagePlaceAnnotation: NSObject,MKAnnotation {
    var currentStore:MQStoreObj?
    var coordinate: CLLocationCoordinate2D
    var stringImage: String?
    var stringId:String?
    var dateCreated:Date?
    var tenCuaHang:String?
    var diachi:String?
    var thoigian:String?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
