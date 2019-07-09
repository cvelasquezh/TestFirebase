//
//  INTColor.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import UIKit

extension UIColor {
    
   fileprivate class func colorToPercent(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    fileprivate class func colorToPercent(red: CGFloat, green: CGFloat, blue: CGFloat,
                              alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    class func INTblue() -> UIColor {
        return colorToPercent(red: 47, green: 151, blue: 209)
    }
    
    class func INTorange() -> UIColor {
        return colorToPercent(red: 253, green: 92, blue: 105)
    }
    
    class func INTpurple() -> UIColor {
        return colorToPercent(red: 138, green: 101, blue: 218)
        
    }
    class func INTgray() -> UIColor {
        return colorToPercent(red: 181, green: 181, blue: 181)
    }
}
