//
//  UIFont+INTFont.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    class func regularINTFont(ofSize size:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    class func boldINTFont(ofSize size:CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    class func lightINTFont(ofSize size:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
}
