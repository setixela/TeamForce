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
    var `default`: [ButtonState] { [
        .backColor(.black),
        .textColor(.white),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .state(.normal),
    ] }

    var transparent: [ButtonState] { [
        .backColor(.white),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .textColor(.black),
        .state(.normal),
    ] }

    var inactive: [ButtonState] { [
        .backColor(.black.withAlphaComponent(0.38)),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .textColor(.white),
        .state(.inactive),
    ] }

    typealias Parameters = GlobalParameters
}

final class DefaultButtonBuilder: ButtonBuilderProtocol {
    lazy var builder: Builder = .init()

    typealias Builder = ButtonStateBuilder

    var `default`: ButtonModel {
        .init(builder.default)
    }

    var transparent: ButtonModel {
        .init(builder.transparent)
    }

    var inactive: ButtonModel {
        .init(builder.inactive)
    }
}
