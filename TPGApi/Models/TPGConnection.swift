//
//  TPGConnection.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 10.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGConnection {
    
    public var lineCode: String
    public var destination: String
    public var destinationCode: String
    
    init(jsonConnection: JSON) {
        self.lineCode = jsonConnection["lineCode"].stringValue
        self.destination = jsonConnection["destinationName"].stringValue
        self.destinationCode = jsonConnection["destinationCode"].stringValue
    }
    
}
