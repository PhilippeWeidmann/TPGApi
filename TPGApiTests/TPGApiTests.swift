//
//  TPGApiTests.swift
//  TPGApiTests
//
//  Created by Philippe Weidmann on 05.11.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import XCTest
@testable import TPGApi

class TPGApiTests: XCTestCase {

    override func setUp() {
        TPGApiKey.key = ""
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetColors() {
        var lineColor = StopManager.instance.getLineColor(code: "12")
        XCTAssertEqual(TPGLineColor.noColor, lineColor)
        
        let expectation = self.expectation(description: "Colors Fetching")
        
        StopManager.instance.getLineColor(code: "12", completion: {(color) in
            
            XCTAssertEqual(UIColor(red: 0, green: 0, blue: 0, alpha: 1), color.textColor)
            XCTAssertEqual(UIColor(red: 1, green: 0.6, blue: 0, alpha: 1), color.backgroundColor)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        lineColor = StopManager.instance.getLineColor(code: "12")
        XCTAssertEqual(UIColor(red: 0, green: 0, blue: 0, alpha: 1), lineColor.textColor)
        XCTAssertEqual(UIColor(red: 1, green: 0.6, blue: 0, alpha: 1), lineColor.backgroundColor)
    }

    
    func testGetStops() {
        measure {
            let stopForceExpect = self.expectation(description: "Stops Fetching")

            StopManager.instance.loadStops(completion: {(commercialStops, physicalStops) in
                XCTAssertNotNil(commercialStops["CVIN"])
                XCTAssertNotNil(physicalStops["CVIN00"])
                
                stopForceExpect.fulfill()
            }, force: true)
            waitForExpectations(timeout: 5, handler: nil)
            let stopNoForceExpect = self.expectation(description: "Stops Fetching")
            
            StopManager.instance.loadStops(completion: {(commercialStops, physicalStops) in
                XCTAssertNotNil(commercialStops["CVIN"])
                XCTAssertNotNil(physicalStops["CVIN00"])
                
                stopNoForceExpect.fulfill()
            }, force: false)
            waitForExpectations(timeout: 5, handler: nil)
        }
    }

    
    func testGetStopFromNameAndDirection(){
        let stopNoForceExpect = self.expectation(description: "Stops Fetching")

        StopManager.instance.loadStops(completion: {(commercialStops, physicalStops) in
            var stops = StopManager.instance.getPhyscialStopsFromName("Vessy")
            XCTAssertEqual(2, stops.count)
            
            stops = StopManager.instance.getPhyscialStopsFromName("Gare Cornavin")
            XCTAssertEqual(15, stops.count)
            
            stops = StopManager.instance.getStopsFromNameAndDirection(name: "Gare Cornavin", direction: "Veyrier-Tournettes")
            XCTAssertEqual(1, stops.count)
            
            stopNoForceExpect.fulfill()
        }, force: false)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDepartures(){
        let departuresExpec = self.expectation(description: "Departure Fetching")
        DeparturesManager.instance.loadNextDeparturesFor(stopCode: "CVIN", completion: {departures in
            XCTAssertGreaterThan(departures.count, 1)
            XCTAssertTrue(departures.contains(where: {$0.lineCode=="14"}))
            departuresExpec.fulfill()
        })
    
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThermometer(){
        let departuresExpec = self.expectation(description: "Thermometer Fetching")
        DeparturesManager.instance.loadThermometerFor(departureCode: "43844", completion: {thermometer in
            let firstStep = thermometer.steps.first!
            XCTAssertEqual("43839", firstStep.departureCode)
            XCTAssertEqual("NATI01", firstStep.stop.code)

            departuresExpec.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    

}
