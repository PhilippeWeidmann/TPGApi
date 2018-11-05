//
//  File.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 11.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

class TPGDeparture: NSObject {
    
    var waitingTime: Int
    var destinationName: String
    var destinationCode: String
    var lineCode: String
    var vehiculeType: VehiculeType
    
    enum VehiculeType {
        case tramway
        case bus
    }

    init(jsonDeparture: JSON){
        self.waitingTime = jsonDeparture["waitingTime"].intValue
        self.destinationName = jsonDeparture["line"]["destinationName"].stringValue
        self.destinationCode = jsonDeparture["line"]["destinationCode"].stringValue
        self.lineCode = jsonDeparture["line"]["lineCode"].stringValue
        self.vehiculeType = jsonDeparture["vehiculeType"].stringValue.starts(with: "TW") ? .tramway : .bus
    }
    
    override var description : String {
        return "\(lineCode) -> \(destinationName) (\(destinationCode)):  \(waitingTime)min"
    }
}
