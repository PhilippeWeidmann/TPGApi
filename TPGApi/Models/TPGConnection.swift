//
//  TPGConnection.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 10.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGConnection: NSObject {
    
    public let lineCode: String
    public let destination: String
    public let destinationCode: String
    
    init(jsonConnection: JSON) {
        self.lineCode = jsonConnection["lineCode"].stringValue
        self.destination = jsonConnection["destinationName"].stringValue
        self.destinationCode = jsonConnection["destinationCode"].stringValue
    }
    
    override public var description : String {
        return "\(lineCode) -> \(destination) (\(destinationCode))"
    }
    
    static func == (lhs: TPGConnection, rhs: TPGConnection) -> Bool {
        return
            lhs.lineCode == rhs.lineCode &&
                lhs.destinationCode == rhs.destinationCode
    }
}

