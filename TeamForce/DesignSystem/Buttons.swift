//
//  ButtonsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import Foundation

// MARK: - Buttons Protocols

protocol ButtonsProtocol {
    associatedtype DesignType

    var `default`: DesignType { get }
    var transparent: DesignType { get }
    var inactive: DesignType { get }
}

protocol ButtonStateBuilderProtocol: ButtonsProtocol {
    associatedtype Parameters: ParametersProtocol
}

protocol ButtonBuilderProtocol: ButtonsProtocol,
    BuilderProtocol where Builder: ButtonStateBuilderProtocol {}

// MARK: - Buttons

struct ButtonStateBuilder: ButtonStateBuilderProtocol {
    var `default`: ButtonState {
        ButtonState()
            .set(\.backColor, .black)
            .set(\.textColor, .white)
            .set(\.cornerRadius, Parameters.cornerRadius)
            .set(\.height, 48)
            .set(\.state, .normal)
    }

    var transparent: ButtonState {
        ButtonState()
            .set(\.backColor, .white)
            .set(\.cornerRadius, Parameters.cornerRadius)
            .set(\.height, 48)
            .set(\.textColor, .black)
            .set(\.state, .normal)
    }

    var inactive: ButtonState {
        ButtonState()
            .set(\.backColor, .black.withAlphaComponent(0.38))
            .set(\.cornerRadius, Parameters.cornerRadius)
            .set(\.height, 48)
            .set(\.textColor, .white)
            .set(\.state, .inactive)
    }

    typealias Parameters = GlobalParameters
}

final class DefaultButtonBuilder: ButtonBuilderProtocol {
    lazy var builder: Builder = .init()

    typealias Builder = ButtonStateBuilder

    var `default`: ButtonModel {
        ButtonModel(state: builder.default)
    }

    var transparent: ButtonModel {
        ButtonModel(state: builder.transparent)
    }

    var inactive: ButtonModel {
        ButtonModel(state: builder.inactive)
    }
}

import UIKit

protocol KeyPathMaker {
    associatedtype MakeType
    associatedtype ValueType

    func make(_ keypath: KeyPath<Self, ValueType>) -> MakeType
}

protocol IconsProtocol: InitProtocol {
    associatedtype IconType

    var checkCircle: IconType { get }
}

struct Icons: IconsProtocol, KeyPathMaker {
    var checkCircle: String { "check_circle_24px" }
}

extension Icons {
    func make(_ keypath: KeyPath<Self, IconType>) -> UIImage {
        let name = self[keyPath: keypath]
        return UIImage(named: name) ?? UIImage()
    }
}

//struct Icons: IconsProtocol {
//    typealias MakeType = UIImage
//
//    typealias ValueType = IconType
//
//    var checkCircle: UIImage { .init(named: "check_circle_24px")! }
//}

//extension Icons {
//    func make
//}
