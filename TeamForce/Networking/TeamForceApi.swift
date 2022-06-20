//
//  TeamForceApi.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.04.2022.
//

import Foundation
import PromiseKit

typealias TeamForceResult<T> = Swift.Result<T, TeamForceApiError>

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum TeamForceApiError: Error {
    case wrongEndpoint
    case jsonParsing
    case error(Error)
}

protocol TeamForceApiProtocol {
}

enum CommonError: Error {
    case error
}


final class TeamForceApi: TeamForceApiProtocol {

    func auth(loginName: String) -> Promise<AuthResult> {
        Promise { seal in
            apiEngine
                .process(endpoint: TeamForceEndpoints.AuthEndpoint(
                    body: ["type": "authorize",
                           "login": loginName]
                ))
                .done { result in
                    guard
                        let xId = result.response?.headerValueFor("X-ID"),
                        let xCode = result.response?.headerValueFor("X-Code")
                    else {
                        seal.reject(ApiEngineError.unknown)
                        return
                    }
                    seal.fulfill(AuthResult(xId: xId,
                                            xCode: xCode))
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }

    func verify(authResult: AuthResult) -> Promise<VerifyResult> {
        Promise { seal in
            apiEngine
                .process(endpoint: TeamForceEndpoints.VerifyEndpoint(body: ["X-ID": authResult.xId,
                                                                            "X-Code": authResult.xCode]))
                .done { result in
                    print(result)
                    seal.fulfill(VerifyResult(type: "", isSuccess: true))
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }


    private let apiEngine: ApiEngineProtocol

    init(engine: ApiEngineProtocol) {
        apiEngine = engine
    }
}

extension TeamForceApi {
//    private func processEndpoint<T: Decodable>(_ endpoint: EndpointProtocol) -> Promise<TeamForceApiResult<T>>
//    {
//        guard let url = URL(string: endpoint.endPoint) else {
//            completion(Swift.Result.failure(.wrongEndpoint))
//            return
//        }
//
//        apiEngine.process(
//            url: url,
//            method: endpoint.method,
//            headers: endpoint.headers,
//            jsonBody: endpoint.body,
//            completion: { result in
//
//                switch result {
//                case let .success(apiResult):
//                    let decoder = JSONDecoder()
//
//                    guard
//                        let data = apiResult.data,
//                        let result = try? decoder.decode(T.self, from: data)
//                    else {
//                        print(apiResult)
//
//                        completion(Swift.Result.failure(.jsonParsing))
//
//                        return
//                    }
//
//                    completion(.success(ApiResult(data: result, response: apiResult.response)))
//
//                case let .failure(error):
//
//                    completion(.failure(.error(error)))
//                }
//            }
//        )
//    }
}

struct AuthResult {
    let xId: String
    let xCode: String
}


struct VerifyResult {
   let type: String //  "authresult",
   let isSuccess: Bool //  false
}


struct VerifyResultBody {
   let type: String //  "authresult",
   let isSuccess: Bool //  false
}

struct AuthResultBody: Decodable {
    let type: String?
    let status: String?
    let error: String?
}

struct ApiResult<T: Decodable> {
    let data: T
    let response: URLResponse?
}

extension URLResponse {
    func headerValueFor(_ key: String) -> String? {
        guard
            let value = (self as? HTTPURLResponse)?.value(forHTTPHeaderField: key)
        else {
            return nil
        }

        print("Header Value for Key (\(key)): ", value)
        return value
    }
}
