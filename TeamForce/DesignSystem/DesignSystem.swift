 //
//  DesignSystem.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

struct DesignSystem: DesignProtocol {
    typealias Font = FontBuilder
    typealias Parameters = GlobalParameters
    typealias Icon = Icons
    typealias State = StateBuilders<Self>
    typealias Button = DefaultButtonBuilder<Self>
    typealias Label = LabelBuilder
    typealias Color = Colors
}

struct GlobalParameters: ParametersProtocol {
    static let cornerRadius: CGFloat = 10
    static var contentPadding: UIEdgeInsets { .init(top: 12, left: 16, bottom: 12, right: 16) }
}

struct StateBuilders<Design: DesignProtocol>: StateBuildersProtocol {
    typealias MainView = MainViewStateBuilder<Design>
    typealias Button = ButtonStateBuilder<Design>
}

