//
//  DesignSystem.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

struct DesignSystem: DesignSystemProtocol {
    typealias Icon = Icons

    typealias State = ModelSetuper

    typealias Button = DefaultButtonBuilder
    typealias Label = LabelBuilder

    static let button = Button()
    static let label = Label()
}

struct GlobalParameters: ParametersProtocol {
    static let cornerRadius: CGFloat = 4
}

struct ModelSetuper: ModelSetuperProtocol {
    typealias MainView = MainViewStateBuilder
    typealias Button = ButtonStateBuilder

    static var mainView: MainView = .init()
    static var button: Button = .init()
}

struct MainViewStateBuilder: MainViewSetuperProtocol {
    var `default`: StackState {
        let state = StackState()
        state
            .set(\.axis, .vertical)
            .set(\.spacing, 0)
            .set(\.alignment, .fill)
            .set(\.distribution, .fill)
            .set(\.padding, UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        return state
    }
}

