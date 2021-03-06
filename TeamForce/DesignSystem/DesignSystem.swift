 //
//  DesignSystem.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

struct DesignSystem: DesignProtocol {
    typealias Parameters = GlobalParameters
    typealias Icon = Icons
    typealias State = ModelSetuper
    typealias Button = DefaultButtonBuilder
    typealias Label = LabelBuilder
}

struct GlobalParameters: ParametersProtocol {
    static let cornerRadius: CGFloat = 6
    static var contentPadding: UIEdgeInsets { .init(top: 12, left: 16, bottom: 12, right: 16) }
}

struct ModelSetuper: ModelSetuperProtocol {
    typealias MainView = MainViewStateBuilder
    typealias Button = ButtonStateBuilder
}

struct MainViewStateBuilder: MainViewSetuperProtocol {
    var `default`: [StackState] { [
        .axis(.vertical),
        .spacing(0),
        .alignment(.fill),
        .distribution(.fill),
        .padding(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    ] }
}
