//
//  DesignSystem.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import ReactiveWorks
import UIKit

struct DesignSystem: DesignProtocol {
   typealias Text = TextBuilder
   typealias Font = FontBuilder
   typealias Params = ParamBuilder
   typealias Icon = IconBuilder
   typealias State = StateBuilders<Self>
   typealias Button = ButtonBuilder<Self>
   typealias Label = LabelBuilder<Self>
   typealias Color = ColorBuilder
}

struct StateBuilders<Design: DesignProtocol>: StateProtocol {
   typealias Button = ButtonStateBuilder<Design>
   typealias Stack = StackStateBuilder<Design>
   typealias Label = LabelStateBuilder<Design>
   typealias TextField = TextFieldStateBuilder<Design>
}
