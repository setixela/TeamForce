//
//  TitledTextFieldY.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

import ReactiveWorks

class TitledTextFieldY<Design: DesignProtocol>:
   M<LabelModel>.D<TextFieldModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.label.title)
            .numberOfLines(0)
            .alignment(.center)
            .padTop(Grid.x8.value)
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .textColor(Design.color.textSecondary)
            .clearButtonMode(.never)
            .padding(.bottom(Grid.x8.value))
      }
      alignment(.center)
   }
}
