//
//  LineColor.swift
//  ArTpg
//
//  Created by Philippe Weidmann on 11.04.18.
//  Copyright © 2018 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TPGLineColor {
    
    public static var noColor = TPGLineColor()

    /**
     The code of the line displayed on the signs
     */
    public let lineCode: String
    /**
     The color of the line icon displayed on the signs
     */
    public let backgroundColor: UIColor
    /**
     The color of the line code text displayed on the signs
     */
    public let textColor: UIColor
    
    init(jsonColor: JSON) {
        self.lineCode = jsonColor["lineCode"].stringValue
        self.backgroundColor = UIColor(hexString: jsonColor["background"].stringValue)
        self.textColor = UIColor(hexString: jsonColor["text"].stringValue)
    }
    
    private init(){
        self.lineCode = ""
        self.backgroundColor = UIColor.darkGray
        self.textColor = UIColor.white
    }
}
extension TPGLineColor: Equatable {
    public static func == (lhs: TPGLineColor, rhs: TPGLineColor) -> Bool {
        return lhs.backgroundColor == rhs.backgroundColor && lhs.textColor == rhs.textColor
    }
}


extension UIColor {
    convenience init(hexString: String){
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
}
