//
//  ApiEngine.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.04.2022.
//

import PromiseKit
import UIKit

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

         request.httpBody = params
            .map { (key: String, value: Any) in
               key + "=\(value)"
            }
            .joined(separator: "&")
            .data(using: .utf8)

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

            let str = String(decoding: data, as: UTF8.self)
            print("result body \(str)")
            print("response status \(String(describing: apiResult.response as? HTTPURLResponse))")

            seal.fulfill(apiResult)
         }

         task.resume()
      }
   }

   func processWithImage(endpoint: EndpointProtocol, image: UIImage) -> Promise<ApiEngineResult> {
      return Promise { seal in
         guard let url = URL(string: endpoint.endPoint) else {
            seal.reject(ApiEngineError.unknown)
            return
         }

         let size = image.size
         let image = image.resized(to: .init(width: size.width/4, height: size.height/4))

         let boundary = UUID().uuidString

         let method = endpoint.method
         let params = endpoint.body
         let headers = endpoint.headers

         var request = URLRequest(url: url)

         request.httpMethod = method.rawValue

         for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
         }
         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

         var data = Data()

         // Add the image data to the raw http request data
         data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
         data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(image.hashValue)\"\r\n".data(using: .utf8)!)
         data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
         data.append(image.pngData()!)

         data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

         let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

         request.httpBody = jsonData
//         params
//            .map { (key: String, value: Any) in
//               key + "=\(value)"
//            }
//            .joined(separator: "&")
//            .data(using: .utf8)

         log(request)

         let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in

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

            let str = String(decoding: data, as: UTF8.self)
            print("result body \(str)")
            print("response status \(String(describing: apiResult.response as? HTTPURLResponse))")

            seal.fulfill(apiResult)
         }

         task.resume()
      }
   }
}

extension UIImage {
   func resized(to size: CGSize) -> UIImage {
      return UIGraphicsImageRenderer(size: size).image { _ in
         draw(in: CGRect(origin: .zero, size: size))
      }
   }
}
