//
//  JsonFetcher.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 10.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DeparturesManager {
    
    static let instance = DeparturesManager()
    
    private init(){
    }

    /**
     Get next departures asynchronously for a commercial stop results sent either to the delegate or the completion block.
     - Parameter stopCode:  The code of commercial stop
     - Parameter sender:  The delegate to callback
     - Parameter completion: The completion results in one array of [TPGDeparture]
     */
    func loadNextDeparturesFor(stopCode: String, completion: @escaping (([TPGDeparture]) -> Void)){
        var departures = [TPGDeparture]()
        let url = "https://prod.ivtr-od.tpg.ch/v1/GetNextDepartures.json?stopCode=\(stopCode)&key=\(TPGApi.key)"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonRootDepartures = JSON(value)
                for jsonDeparture in jsonRootDepartures["departures"].arrayValue{
                    if(jsonDeparture["waitingTime"].stringValue != "no more" && jsonDeparture["waitingTime"].stringValue != "&gt;1h"){
                        departures.append(TPGDeparture(jsonDeparture: jsonDeparture))
                    }
                }
                
                completion(departures)
            case .failure(_):
                completion(departures)
            }
        }
    }
    
}
