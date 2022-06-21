//
//  InitProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

protocol InitProtocol {
    init()
}

class BaseClass: InitProtocol {
    required init() {}
}
