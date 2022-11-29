//
//  Localizable.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 29.11.2022.
//

import Foundation

struct Localizable {

}

protocol LocalizableDelegate {
    var rawValue: String { get }    //localize key
    var fileName: String? { get }
    var localized: String { get }
    var uppercaseLocalized: String { get }
}

extension LocalizableDelegate {
    /// returns a localized value by specified key located in the specified table
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: fileName)
    }

    /// returns a uppercased localize value by specified key located in the specified table
    var uppercaseLocalized: String {
        return localized.uppercased()
    }

    /// file name, where to find the localized key
    /// by default is the Localizable.string table
    var fileName: String? {
        return nil
    }
}
