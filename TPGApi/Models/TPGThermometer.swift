//
//  TPGThermometer.swift
//  TPGApi
//
//  Created by Philippe Weidmann on 08.11.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGThermometer: NSObject {
    
    private let dateFormatterGet = DateFormatter()

    private let currentTimestamp: Date
    public let lineCode: String
    public let destinationName: String
    public let destinationCode: String
    public var steps: [TPGStep]
    
    public init(jsonThermometer: JSON){
        self.currentTimestamp = Date()
        self.lineCode = jsonThermometer["lineCode"].stringValue
        self.destinationCode = jsonThermometer["destinationCode"].stringValue
        self.destinationName = jsonThermometer["destinationName"].stringValue
        self.steps = [TPGStep]()
        for jsonStep in jsonThermometer["steps"].arrayValue{
            steps.append(TPGStep(jsonStep: jsonStep))
        }
    }
    
    public func getTimeUntilStep(_ step: Int) -> Double{
        return steps[step].timestamp.timeIntervalSince(currentTimestamp)
    }
    
    public func getIndexOfStepFromStop(_ code: String) -> Int?{
        return steps.firstIndex(where: {$0.stop.commercialCode == code})
    }
    
    override public var description : String {
        return "\(lineCode) -> \(destinationName) (\(destinationCode))"
    }
}
