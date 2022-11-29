//
//  Splash+Localizable.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 29.11.2022.
//

import Foundation

extension Localizable {
    enum Splash: String, LocalizableDelegate {
        case welcomeMessage = "Splash_Welcome_Message"
        case helloMessage = "Splash_Hello_Message"

        var fileName: String? {
            return "Splash+Localizable"
        }
    }
}
