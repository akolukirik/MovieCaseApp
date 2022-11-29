//
//  UIColor+Ext.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

extension UIColor {
    
    fileprivate static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static var softBlue: UIColor {
        return rgb(red: 100, green: 136, blue: 250, alpha: 1)
    }
    
    static var softBlack: UIColor {
        return rgb(red: 51, green: 78, blue: 104, alpha: 1)
    }
}
