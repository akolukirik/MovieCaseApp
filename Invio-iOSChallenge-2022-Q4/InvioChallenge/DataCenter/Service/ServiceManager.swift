//
//  ServiceManager.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 22.11.2022.
//

import Foundation
import Alamofire

final class ServiceManager: NSObject {
    public static let shared: ServiceManager = ServiceManager()

    fileprivate var session = AF

    private override init() {
        super.init()
        session = Session()
    }
}

extension ServiceManager {
    @discardableResult
    func performRequest<T: Decodable>(endpoint: BaseEndPointRouter,
                                      decoder: DataDecoder = JSONDecoder(),
                                      onSuccess: @escaping (T?) -> Void,
                                      onError: @escaping (AFError) -> Void) -> DataRequest {
        return session.request(endpoint)
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: T.self) { (requestResponse) in
                switch requestResponse.result {
                case .success:
                    onSuccess(requestResponse.value)
                case .failure(let error):
                    onError(error)
                }
            }
    }
}
