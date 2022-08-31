//
//  ApiEngineProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

import Foundation
import PromiseKit
import UIKit

protocol ApiEngineProtocol {
   func process(endpoint: EndpointProtocol) -> Promise<ApiEngineResult>
   func processWithImage(endpoint: EndpointProtocol, image: UIImage) -> Promise<ApiEngineResult>
}
