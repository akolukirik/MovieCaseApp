//
//  MovieModel.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation

struct MovieModel: Decodable {
    var results: [MovieResult]?
    var totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case results = "Search"
        case totalResults
        case response = "Response"
    }
}

struct MovieResult: Decodable {
    var title, year, imdbID: String?
    var type: TypeEnum?
    var poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Decodable {
    case movie = "movie"
    case series = "series"
    case game = "game"
}
