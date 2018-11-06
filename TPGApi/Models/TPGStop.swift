//
//  TPGStop.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 10.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

public class TPGStop {
    
    var commercialCode: String
    var code: String
    var name: String
    var latitude: Double
    var longitude: Double
    var location: CLLocation
    var connections: [TPGConnection]

    init(commercialCode: String, jsonTpgStop: JSON) {
        self.commercialCode = commercialCode
        self.code = jsonTpgStop["physicalStopCode"].stringValue
        self.name = jsonTpgStop["stopName"].stringValue
        self.latitude = jsonTpgStop["coordinates"]["latitude"].doubleValue
        self.longitude = jsonTpgStop["coordinates"]["longitude"].doubleValue
        self.location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        self.connections = [TPGConnection]()
        for jsonConnection in jsonTpgStop["connections"].arrayValue{
            connections.append(TPGConnection(jsonConnection: jsonConnection))
        }
    }

    
}
