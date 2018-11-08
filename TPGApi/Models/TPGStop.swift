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
    
    public let commercialCode: String
    public let code: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let location: CLLocation
    public var connections: [TPGConnection]

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
