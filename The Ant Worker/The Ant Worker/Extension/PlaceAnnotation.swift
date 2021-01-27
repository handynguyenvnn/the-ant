//
//  WHImagePlaceAnnotation.swift
//  whh
//
//  Created by MAC on 12/14/16.
//  Copyright © 2016 Hoang Mai Long. All rights reserved.
//

import MapKit
class PlaceAnnotation: NSObject,MKAnnotation {
    var currentStore:TAJobObj?
    var coordinate: CLLocationCoordinate2D
    var stringImage: String?
    var stringId:String?
    var dateCreated:Date?
    var address:String?
    var name:String?
    var time:String?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
