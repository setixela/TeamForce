//
//  InitProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

protocol InitProtocol {
    init()
}

protocol StateBuilderProtocol: InitProtocol {
    associatedtype StateBuilder

    var builder: StateBuilder { get }
}

class BaseClass: InitProtocol {
    required init() {}
}

class BaseState: BaseClass {
    required init() {}
}
