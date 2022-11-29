//
//  SimpleEndPointRouter.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation
import Alamofire

extension SimpleEndPointRouter {
    private enum Constants {
        enum BaseUrl {
            static let baseUrl = "https://www.omdbapi.com/"
        }
        static let API_KEY: String = "7a470613"
    }
}

enum SimpleEndPointRouter: BaseEndPointRouter {
    case movieList(searchText: String, pageNumber: Int)
    case movieDetail(imdbID: String)
    case test

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .movieList, .movieDetail:
            return .get
        default:
            return .post
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .movieList(let searchText, let pageNumber):
            return "?s=\(searchText)&page=\(pageNumber)&apikey=\(Constants.API_KEY)"
        case .movieDetail(let imdbID):
            return "?i=\(imdbID)&apikey=\(Constants.API_KEY)"
        default: return ""
        }
    }

    // MARK: - baseURL
    private var baseURL: String {
        switch self {
        case .movieList, .movieDetail:
            return Constants.BaseUrl.baseUrl
        default:
            return ""
        }
    }

    // MARK: - ParameterEncoding
    private var encoder: ParameterEncoding {
        if self.method == HTTPMethod.get {
            return URLEncoding()
        } else {
            return JSONEncoding()
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {

        // Request URL
        let url = try  baseURL.asURL().appendingPathComponent(path).absoluteString.removingPercentEncoding!.asURL()

        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Headers
        let jsonHeader = "application/json"
        urlRequest.headers.add(.accept(jsonHeader))
        urlRequest.headers.add(.contentType(jsonHeader))

        do {
            urlRequest = try encoder.encode(urlRequest, with: parameters)
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return urlRequest
    }

    private func queryString(_ value: String, params: Parameters) -> URL? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in
            URLQueryItem(name: element.key,
                         value: element.value as? String)
        }
        return components?.url
    }
}
