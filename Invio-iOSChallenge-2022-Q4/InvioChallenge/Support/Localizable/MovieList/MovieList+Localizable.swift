//
//  MovieList+Localizable.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 29.11.2022.
//

import Foundation

extension Localizable {
    enum MovieList: String, LocalizableDelegate {
        case emptyResponseMessage = "MovieList_EmptyResponse_Message"
        case searchingMessage = "MovieList_Searching_Message"
        case apiError = "MovieList_FetchingError_Message"
        case navigateFailure = "MovieList_NavigateFailure_Message"
        case makeSearch = "MovieList_MakeSearching_Message"
        var fileName: String? {
            return "MovieList+Localizable"
        }
    }
}

