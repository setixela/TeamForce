//
//  ApiEngine.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.04.2022.
//

import Foundation
import PromiseKit

enum ApiEngineError: Error {
    case unknown
    case error(Error)
}

struct ApiEngineResult {
    let data: Data?
    let response: URLResponse?
}

//typealias ApiEngineCallback = GenericClosure<Swift.Result<ApiEngineResult, ApiEngineError>>

final class ApiEngine: ApiEngineProtocol {
//    func process(url: URL,
//                 method: HTTPMethod,
//                 headers: [String: String] = [:],
//                 params: [String: Any] = [:]) -> Promise<ApiEngineResult>
//

    func process(endpoint: EndpointProtocol) -> Promise<ApiEngineResult> {
        return Promise { seal in
            guard let url = URL(string: endpoint.endPoint) else {
                seal.reject(ApiEngineError.unknown)
                return
            }

            let method = endpoint.method
            let params = endpoint.body
            let headers = endpoint.headers

            var request = URLRequest(url: url)

            request.httpMethod = method.rawValue

            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }

            request.httpBody = params
                .map { (key: String, value: Any) in
                    key + "=\(value)"
                }
                .joined(separator: "&")
                .data(using: .utf8)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print("\nResponse:\n\(response)\n\nData:\n\(data)\n\nError:\n\(error))")
                guard let data = data else {
                    guard let error = error else {
                        seal.reject(ApiEngineError.unknown)
                        return
                    }

                    print(error)
                    seal.reject(ApiEngineError.error(error))
                    return
                }

                let apiResult = ApiEngineResult(data: data, response: response)
                seal.fulfill(apiResult)
            }

            task.resume()
        }
    }

//    func process(url: URL,
//                 method: HTTPMethod,
//                 headers: [String: String] = [:],
//                 jsonBody: [String: Any] = [:],
//                 completion: @escaping ApiEngineCallback)
//    {
//        var request = URLRequest(url: url)
//
//        request.httpMethod = method.rawValue
//
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//
//        request.httpBody = jsonBody
//            .map { (key: String, value: Any) in
//                key + "=\(value)"
//            }
//            .joined(separator: "&")
//            .data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                guard let error = error else {
//                    completion(Swift.Result.failure(.unknown))
//                    return
//                }
//
//                print(error)
//                completion(Swift.Result.failure(.error(error)))
//                return
//            }
//
//            let apiResult = ApiEngineResult(data: data, response: response)
//            completion(Swift.Result.success(apiResult))
//        }
//
//        task.resume()
//    }
}
