//
//  Lambda.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import Foundation

public typealias VoidClosure = () -> Void
public typealias Event<T> = (T) -> Void

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
