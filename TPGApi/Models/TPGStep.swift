//
//  TPGStep.swift
//  TPGApi
//
//  Created by Philippe Weidmann on 08.11.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGStep {
    
    private let dateFormatterGet = DateFormatter()
    
    /**
     The departure code coresponding to (timestamp - stop - line)
     */
    public let departureCode: String
    /**
     When the bus should reach to this step
     */
    public let timestamp: Date
    /**
     Stop corresponding to step
     */
    public let stop: TPGStop
    
    public init(jsonStep: JSON){
        self.departureCode = jsonStep["departureCode"].stringValue
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatterGet.date(from: jsonStep["timestamp"].stringValue){
            self.timestamp = date
        }
        else{
            print("failed to parse date")
            self.timestamp = Date()
        }
        self.stop = TPGStop(commercialCode: jsonStep["stop"]["stopCode"].stringValue, jsonTpgStop: jsonStep["physicalStop"])
    }
}
