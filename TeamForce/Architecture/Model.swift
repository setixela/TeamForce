//
//  Model.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.05.2022.
//

import Foundation

protocol ModelProtocol: AnyObject {
    func start()
}

class BaseModel<Events: InitProtocol>: NSObject, ModelProtocol, Communicable {
    func start() {
        print("Needs to override start()")
    }

    var eventsStore: Events = .init()

    override init() {
        super.init()
        start()
    }

}

