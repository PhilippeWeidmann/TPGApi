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
    
    public var waitingTime: Int
    public var destinationName: String
    public var destinationCode: String
    public var lineCode: String
    public var vehiculeType: VehiculeType
    
    public enum VehiculeType {
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
    
    override public var description : String {
        return "\(lineCode) -> \(destinationName) (\(destinationCode)):  \(waitingTime)min"
    }
}
