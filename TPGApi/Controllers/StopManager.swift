//
//  StopManager.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 11.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MapKit

public class StopManager {
    
    public static let instance = StopManager()
    public private(set) var physicalStops = [String : TPGStop]()
    public private(set) var stops = [String : TPGStop]()

    private var lineColors = [String : TPGLineColor]()
    
    private init(){
    }
    
    /**
     Try to get the stops from the cache. If no cache is available, the stops are fetched asynchronously online.
     
     - Parameter completion: The completion results in one array of commercial [TPGStop], second is an array of physical [TPGStop]
     - Parameter force: Optional parameter to force getting the stops online
     */
    public func loadStops(completion: (([String : TPGStop],[String : TPGStop]) -> Void)? = nil, force: Bool? = false){
        if(force!){
            self.fetchStops(completion: completion)
        }
        else{
            if(stops.count > 0){
                if let unwrappedCompletion = completion{
                    unwrappedCompletion(stops, physicalStops)
                }
                return
            }
            
            var content="{}"
            let fileStops = FileSaveHelper(fileName: "stops", fileExtension: .json)
            do {
                content = try fileStops.getContentsOfFile()
                let jsonRootStops = JSON(parseJSON: content)
                self.parseStopsFrom(json: jsonRootStops)
                
                
                if let unwrappedCompletion = completion{
                    unwrappedCompletion(stops, physicalStops)
                }
            }
            catch {
                self.fetchStops(completion: completion)
            }
        }
    }
    
    private func fetchStops(completion: (([String : TPGStop],[String : TPGStop]) -> Void)? = nil){
        let url = "https://prod.ivtr-od.tpg.ch/v1/GetPhysicalStops.json?key=\(TPGApiKey.key)"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonRootStops = JSON(value)
                self.parseStopsFrom(json: jsonRootStops)
                
                let fileStops = FileSaveHelper(fileName: "stops", fileExtension: .json)
                do {
                    try fileStops.saveFileWith(fileContents: jsonRootStops.rawString()!)
                }
                catch {
                    print("There was an error saving the file: \(error)")
                }
                
                if let unwrappedCompletion = completion{
                    unwrappedCompletion(self.stops, self.physicalStops)
                }
            case .failure(let error):
                print(error)
                if let unwrappedCompletion = completion{
                    unwrappedCompletion(self.stops, self.physicalStops)
                }
            }
        }
    }
    
    private func parseStopsFrom(json: JSON){
        for jsonStop in json["stops"].arrayValue{
            let commercialStop = TPGStop(commercialCode: jsonStop["stopCode"].stringValue,jsonTpgStop: jsonStop["physicalStops"].arrayValue.first!)
            
            for jsonPhysicalStop in jsonStop["physicalStops"].arrayValue{
                let stop = TPGStop(commercialCode: jsonStop["stopCode"].stringValue,jsonTpgStop: jsonPhysicalStop)
                
                commercialStop.connections.mergeElements(newElements: stop.connections)
                
                physicalStops[stop.code] = stop
            }
            
            stops[commercialStop.commercialCode] = commercialStop
        }
    }
    
    
    /**
     Get stops from a name
     
     - Parameter name: The stop name as seen on a sign
     - Returns: An array of stops matching this name
     */
    public func getPhyscialStopsFromName(_ name: String) -> [TPGStop] {
        var stops = [TPGStop]()
        stops.append(contentsOf: physicalStops.values.filter({$0.name == name}))
        
        return stops
    }
    
    /**
     Get stops from a name and a direction
     
     - Parameter name: The stop name as seen on a sign
     - Parameter direction: The line destination name as seen on a sign
     - Returns: An array of stops matching this name and direction (should always be of size 1)
     */
    public func getStopsFromNameAndDirection(name: String, direction: String) -> [TPGStop] {
        let formattedDirection = direction.lowercased()
        var stops = [TPGStop]()
        
        for stop in self.getPhyscialStopsFromName(name) {
            for connection in stop.connections {
                if(connection.destination.lowercased() == formattedDirection){
                    stops.append(stop)
                }
            }
        }
        
        return stops
    }
    
    /**
     Get the line color for a given line code
     
     - Parameter code: The line code displayed on the sign
     - Returns: A line color object representing the colors seen on the sign
     */
    public func getLineColor(code: String) -> TPGLineColor {
        if let color = lineColors[code]{
            return color
        }
        return TPGLineColor.noColor
    }
    
    /**
     Get the line color for a given line code asynchronously
     
     - Parameter code: The line code displayed on the sign
     - Parameter completion: The delegate called after completion
     - Returns: A line color object representing the colors seen on the sign
     */
    public func getLineColor(code: String? = "", completion: @escaping ((TPGLineColor) -> Void), force: Bool? = false) {
        let url = "https://prod.ivtr-od.tpg.ch/v1/GetLinesColors.json?key=\(TPGApiKey.key)"
        
        if(!force! && lineColors.count > 0){
            completion(self.getLineColor(code: code!))
        }
        else{
            Alamofire.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonRootColors = JSON(value)
                    self.parseColorsFrom(json: jsonRootColors)
                    
                    let fileColors = FileSaveHelper(fileName: "colors", fileExtension: .json)
                    do {
                        try fileColors.saveFileWith(fileContents: jsonRootColors.rawString()!)
                    }
                    catch {
                        print("There was an error saving the color cache file: \(error)")
                    }
                    
                    if let color = self.lineColors[code!]{
                        completion(color)
                    }
                    else{
                        completion(TPGLineColor.noColor)
                    }
                    
                case .failure(_):
                    do{
                        let fileColors = FileSaveHelper(fileName: "colors", fileExtension: .json)
                        let content = try fileColors.getContentsOfFile()
                        let jsonRootColors = JSON(parseJSON: content)
                        self.parseColorsFrom(json: jsonRootColors)
                        
                        if let color = self.lineColors[code!]{
                            completion(color)
                        }
                        else{
                            completion(TPGLineColor.noColor)
                        }
                        
                    }
                    catch{
                        completion(TPGLineColor.noColor)
                    }
                }
            }
        }
    }
    
    private func parseColorsFrom(json: JSON){
        for jsonColor in json["colors"].arrayValue{
            self.lineColors[jsonColor["lineCode"].stringValue] =  TPGLineColor(jsonColor: jsonColor)
        }
    }
    

}
