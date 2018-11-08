//
//  File.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 11.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGDeparture: NSObject {
    
    public let departureCode: String
    public let waitingTime: Int
    public let destinationName: String
    public let destinationCode: String
    public let lineCode: String
    public let vehiculeType: VehiculeType
    
    public enum VehiculeType {
        case tramway
        case bus
    }

    init(jsonDeparture: JSON){
        self.departureCode = jsonDeparture["departureCode"].stringValue
        self.waitingTime = jsonDeparture["waitingTime"].intValue
        self.destinationName = jsonDeparture["line"]["destinationName"].stringValue
        self.destinationCode = jsonDeparture["line"]["destinationCode"].stringValue
        self.lineCode = jsonDeparture["line"]["lineCode"].stringValue
        self.vehiculeType = jsonDeparture["vehiculeType"].stringValue.starts(with: "TW") ? .tramway : .bus
    }
    
    override public var description : String {
        return "\(lineCode) -> \(destinationName) (\(destinationCode)):  \(waitingTime)min"
    }
}
