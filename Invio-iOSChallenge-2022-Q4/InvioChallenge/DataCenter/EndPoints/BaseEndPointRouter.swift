//
//  BaseEndPointRouter.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation
import Alamofire

public protocol BaseEndPointRouter: URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}
