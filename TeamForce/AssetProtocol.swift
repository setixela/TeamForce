//
//  AssetProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

protocol ServiceProtocol: InitProtocol {
    var apiEngine: ApiEngineProtocol { get }
}

protocol AssetProtocol {
    associatedtype Scene: InitProtocol
    associatedtype Service: ServiceProtocol
    associatedtype Design: DesignProtocol
    associatedtype Text: TextsProtocol

    static var router: Router<Scene>? { get set }
    static var service: Service { get }

    typealias Asset = Self
}

extension AssetProtocol {
    static var service: Service { Service() }
}
