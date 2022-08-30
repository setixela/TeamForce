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

final class ApiEngine: ApiEngineProtocol {
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

         if method == .get {
            request.httpBody = params
               .map { (key: String, value: Any) in
                  key + "=\(value)"
               }
               .joined(separator: "&")
               .data(using: .utf8)
         } else {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
         }

         let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
               guard let error = error else {
                  seal.reject(ApiEngineError.unknown)
                  print("\nResponse:\n\(String(describing: response))\n\nData:\n\(String(describing: data))\n\nError:\n\(String(describing: error)))")
                  return
               }

               print("\nResponse:\n\(String(describing: response))\n\nData:\n\(String(describing: data))\n\nError:\n\(String(describing: error)))")
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
}
