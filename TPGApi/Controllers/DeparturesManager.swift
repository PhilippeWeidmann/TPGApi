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

public class DeparturesManager {
    
    public static let instance = DeparturesManager()
    
    private init(){
    }

    /**
     Get next departures asynchronously for a commercial stop results sent either to the delegate or the completion block.
     - Parameter stopCode:  The code of the commercial stop
     - Parameter completion: The completion results in one array of [TPGDeparture]
     */
    public func loadNextDeparturesFor(stopCode: String, completion: @escaping (([TPGDeparture]) -> Void)){
        var departures = [TPGDeparture]()
        let url = "https://prod.ivtr-od.tpg.ch/v1/GetNextDepartures.json?stopCode=\(stopCode)&key=\(TPGApiKey.key)"
        
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
    
    /**
     Get the step (stop) list for a given departure code. This method returns all the steps for the line even the ones before current time
     - Parameter departureCode:  The code of the departure
     - Parameter completion: The completion result in a TPGThermometer
     */
    public func loadThermometerFor(departureCode: String, completion: @escaping ((TPGThermometer) -> Void)){
        let url = "https://prod.ivtr-od.tpg.ch/v1/GetThermometerPhysicalStops.json?departureCode=\(departureCode)&key=\(TPGApiKey.key)"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonRootSteps = JSON(value)
                
                completion(TPGThermometer(jsonThermometer: jsonRootSteps))
            case .failure(_):
                print("error")
            }
        }
    }
    
}
