//
//  AssetProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

protocol ServiceProtocol: InitProtocol {
    var apiEngine: ApiEngineProtocol { get }
    var safeStringStorage: StringStorage { get }
}

protocol AssetProtocol {
    associatedtype Scene: ScenesProtocol
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

protocol ScenesProtocol: InitProtocol {
    var digitalThanks: SceneModelProtocol { get }
    var login: SceneModelProtocol { get }
    var verifyCode: SceneModelProtocol { get }
    var loginSuccess: SceneModelProtocol { get }
    var register: SceneModelProtocol { get }
    var main: SceneModelProtocol { get }
}


