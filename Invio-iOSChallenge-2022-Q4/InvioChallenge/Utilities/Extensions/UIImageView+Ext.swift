//
//  UIImageView+Ext.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(imageURL: String) {
        self.kf.setImage(with: URL(string: imageURL))
    }
}
