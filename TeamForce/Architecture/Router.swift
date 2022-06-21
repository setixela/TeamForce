//
//  Router.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

import UIKit

enum NavType {
    case push
    case pop
    case popToRoot
}

final class Router<Scene: InitProtocol>: RouterProtocol, Communicable {
    var eventsStore: Events = .init()

    func start() {}

    struct Events: InitProtocol {
        var push: Event<UIViewController>?
        var pop: Event<Void>?
        var popToRoot: Event<Void>?
    }

    func route(_ keypath: KeyPath<Scene, SceneModelProtocol>, navType: NavType, payload: Any? = nil) {
        switch navType {
        case .push:
            let sceneModel = Scene()[keyPath: keypath]
            sceneModel.setInput(payload)
            let vc = sceneModel.makeVC()
            sendEvent(\.push, payload: vc)
        case .pop:
            sendEvent(\.pop)
        case .popToRoot:
            sendEvent(\.popToRoot)
        }
    }
}
