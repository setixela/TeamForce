//
//  EndpointProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

import Foundation

protocol EndpointProtocol {
	var endPoint: String { get }
	var method: HTTPMethod { get }
	var headers: [String: String] { get }
    var body: [String: Any] { get }
   var arrayBody: Array<[String: Any]>? { get }
	var interpolateFunction: (() -> String)? { get }
}

extension EndpointProtocol {
    var headers: [String: String] { [:] }
    var body: [String: Any] { [:] }
    var interpolateFunction: (() -> String)? { nil }
   var arrayBody: Array<[String: Any]>? { nil }

	var interpolated: String { interpolateFunction?() ?? "" }
}
