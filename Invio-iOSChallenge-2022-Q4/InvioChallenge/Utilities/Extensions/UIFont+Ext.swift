//
//  UIFont+Ext.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

extension UIFont {
    
    enum Avenir: String {
        case Book, Medium, Heavy
    }
    
    static func avenir(_ type: UIFont.Avenir, size: CGFloat) -> UIFont {
        return UIFont.init(name: "Avenir-\(type.rawValue)", size: size)!
    }
}
