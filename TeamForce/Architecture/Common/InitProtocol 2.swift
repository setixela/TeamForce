//
//  InitProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

protocol InitProtocol {
    init()
}

protocol BuilderProtocol: InitProtocol {
    associatedtype Builder

    var builder: Builder { get }
}

class BaseClass: InitProtocol {
    required init() {}
}

class BaseState: BaseClass {
    required init() {}
}
