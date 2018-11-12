//
//  Array+Extensions.swift
//  TPGApi
//
//  Created by Philippe Weidmann on 08.11.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    
    public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
    
}
