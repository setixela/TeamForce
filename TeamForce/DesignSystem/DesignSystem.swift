//
//  DesignSystem.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import ReactiveWorks
import UIKit

struct DesignSystem: DesignProtocol {
   typealias Text = Texts
   typealias Font = FontBuilder
   typealias Params = GlobalParameters
   typealias Icon = Icons
   typealias State = StateBuilders<Self>
   typealias Button = DefaultButtonBuilder<Self>
   typealias Label = LabelBuilder
   typealias Color = Colors
}

struct StateBuilders<Design: DesignProtocol>: StateProtocol {
   typealias Button = ButtonStateBuilder<Design>
   typealias Stack = StackStateBuilder<Design>
   typealias Label = LabelStateBuilder
}
