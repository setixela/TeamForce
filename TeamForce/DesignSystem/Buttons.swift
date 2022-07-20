//
//  ButtonsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import UIKit

protocol Associated {
    associatedtype AsType
}

// MARK: - Buttons Protocols

protocol ButtonsProtocol: InitProtocol, Associated {
    associatedtype AsType

    var `default`: AsType { get }
    var transparent: AsType { get }
    var inactive: AsType { get }

    var tabBar: AsType { get }
}

protocol ButtonStateBuilderProtocol: ButtonsProtocol where AsType == [ButtonState] {
    associatedtype Parameters: ParametersProtocol
}

protocol ButtonBuilderProtocol: ButtonsProtocol, StateBuilderProtocol
    where StateBuilder: ButtonStateBuilderProtocol, AsType == ButtonModel
{}

// MARK: - Buttons

struct ButtonStateBuilder: ButtonStateBuilderProtocol {
    var `default`: [ButtonState] { [
        .backColor(UIColor(hex: "#7F39BFFF")!),
        .textColor(.white),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .enabled(true),
    ] }

    var transparent: [ButtonState] { [
        .backColor(.white),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .textColor(.black),
        .enabled(true),
    ] }

    var inactive: [ButtonState] { [
        .backColor(UIColor(hex: "#E9D5FEFF")!),
        .cornerRadius(Parameters.cornerRadius),
        .height(48),
        .textColor(.white),
        .enabled(false),
    ] }

    var tabBar: [ButtonState] { [
        .font(UIFont.systemFont(ofSize: 12, weight: .medium)),
        .backColor(.black.withAlphaComponent(0.38)),
        .cornerRadius(0),
        .height(56),
        .textColor(.white),
        .enabled(true),
        .tint(.white),
        .vertical(true)
    ] }

    typealias Parameters = GlobalParameters
}

final class DefaultButtonBuilder: ButtonBuilderProtocol {
    lazy var builder: ButtonStateBuilder = .init()

    var `default`: ButtonModel {
        .init(builder.default)
    }

    var transparent: ButtonModel {
        .init(builder.transparent)
    }

    var inactive: ButtonModel {
        .init(builder.inactive)
    }

    var tabBar: ButtonModel {
        .init(builder.tabBar)
    }
}
