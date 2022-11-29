//
//  Service.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation
import Alamofire

protocol ServiceProtocol {
    func fetchMovies(searchText: String, pageNumber: Int, onSuccess: @escaping (MovieModel?) -> Void, onError: @escaping (AFError) -> Void)
    func movieDetail(imdbID: String, onSuccess: @escaping (MovieDetailModel?) -> Void, onError: @escaping (AFError) -> Void)
}

//MARK: - Service
final class Service: ServiceProtocol {
    func fetchMovies(searchText: String, pageNumber: Int, onSuccess: @escaping (MovieModel?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.performRequest(endpoint: SimpleEndPointRouter.movieList(searchText: searchText,
                                                                                      pageNumber: pageNumber )) { (response: MovieModel?) in
            onSuccess(response)
        } onError: { error in
            onError(error)
        }
    }
    
    func movieDetail(imdbID: String, onSuccess: @escaping (MovieDetailModel?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.performRequest(endpoint: SimpleEndPointRouter.movieDetail(imdbID: imdbID)) { (response: MovieDetailModel?) in
            onSuccess(response)
        } onError: { error in
            onError(error)
        }
    }
}
