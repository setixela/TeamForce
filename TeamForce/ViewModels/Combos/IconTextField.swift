//
//  IconTextField.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation

final class IconTextField<Design: DesignProtocol>:
   Combos<SComboMR<
      ImageViewModel, TextFieldModel<Design>
   >>
{
   required init() {
      super.init()

      setMain {
         $0
            .setSize(.square(Grid.x24.value))
            .setImage(Design.icon.user)
      } setRight: {
         $0
            .set(Design.state.textField.invisible)
      }
      set(Design.state.stack.inputContent)
      setAlignment(.center)
      setHeight(Design.params.buttonHeight)
      setBackColor(Design.color.backgroundSecondary)
   }
}
