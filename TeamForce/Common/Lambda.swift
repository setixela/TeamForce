//
//  Lambda.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

typealias VoidClosure = () -> Void
typealias GenericClosure<T> = (T) -> Void
typealias Event = GenericClosure

protocol LambdaProtocol {
    func perform<AnyType>(_ value: AnyType)
}

/// <#Description#>
struct Lambda<T>: LambdaProtocol where T: Any {
    func perform<AnyType>(_ value: AnyType) where AnyType: Any {
        guard let value = value as? T else {
            print("Lambda payloads not conform: {\(value.self)} is not {\(T.self)}")
            return
        }

        lambda(value)
    }

    let lambda: Event<T>
}
