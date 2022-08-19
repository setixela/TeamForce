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
   typealias Icon = IconBuilder
   typealias Color = ColorBuilder
   typealias Font = FontBuilder
   typealias Label = LabelBuilder<Self>
   typealias Button = ButtonBuilder<Self>

   typealias Params = ParamBuilder<Self>
   typealias State = StateBuilders<Self>
}

struct StateBuilders<Design: DesignProtocol>: StateProtocol {
   typealias Stack = StackStateBuilder<Design>
   typealias Label = LabelStateBuilder<Design>
   typealias Button = ButtonStateBuilder<Design>
   typealias TextField = TextFieldStateBuilder<Design>
}
