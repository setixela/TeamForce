//
//  ApiEngineProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

import Foundation
import PromiseKit

protocol ApiEngineProtocol {
    //	func process(url: URL,
    //	             method: HTTPMethod,
    //	             headers: [String: String],
//                 jsonBody: [String: Any],
//                 completion: @escaping GenericClosure<Result<ApiEngineResult, ApiEngineError>>)

//    func process(url: URL, method: HTTPMethod, headers: [String: String], params: [String: Any]) -> Promise<ApiEngineResult>

    func process(endpoint: EndpointProtocol) -> Promise<ApiEngineResult>
}
