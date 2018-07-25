//
//  CLPlacemark.swift
//  Bikes
//
//  Created by Kamil Gacek on 25.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//


import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
