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

   var textField: TextFieldModel<Design> { models.right }
   var icon: ImageViewModel { models.main }

   required init() {
      super.init()

      setMain {
         $0
            .set_size(.square(Grid.x24.value))
            .set_image(Design.icon.user)
      } setRight: {
         $0
            .set(Design.state.textField.invisible)
      }
      set(Design.state.stack.inputContent)
      set_alignment(.center)
      set_height(Design.params.buttonHeight)
   }
}
