//
//  Helper+Locazlizable.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 29.11.2022.
//

import Foundation

extension Localizable {
    enum Helper: String, LocalizableDelegate {
        case notAttendantMessage = "Helper_NotAttendant_Message"
        case assertionFailureMessage = "Helper_AssertionFailure_Message"

        var fileName: String? {
            return "Helper+Localizable"
        }
    }
}
