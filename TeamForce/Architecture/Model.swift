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

class BaseModel: NSObject, ModelProtocol {
    func start() {
        print("Needs to override start()")
    }

    override init() {
        super.init()
        start()
    }
}

