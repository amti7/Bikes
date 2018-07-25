//
//  Bike.swift
//  Bikes
//
//  Created by Kamil Gacek on 24.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import ObjectMapper

class BikeStation: Mappable  {
    required init?(map: Map) {
        self.id = ""
        self.name = ""
        self.distance = ""
        self.availablePlaces = ""
        self.availableBikes = ""
        self.coordinateX = 0.00
        self.coordinateY = 0.00
    }

    var id: String
    var name: String
    var distance: String
    var availableBikes: String
    var availablePlaces: String
    var coordinateX: Float
    var coordinateY: Float
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["properties.label"]
        availableBikes <- map["properties.bikes"]
        availablePlaces <- map["properties.free_racks"]
        coordinateX <- map["geometry.coordinates.0"]
        coordinateY <- map["geometry.coordinates.1"]

    }
}
