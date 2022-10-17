//
//  IconTextField.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation

final class IconTextField<Design: DesignProtocol>:
   Combos<SComboMR<
      ImageViewModel, TextFieldModel
   >>
{

   var textField: TextFieldModel { models.right }
   var icon: ImageViewModel { models.main }

   required init() {
      super.init()

      setMain {
         $0
            .size(.square(Grid.x24.value))
      } setRight: {
         $0
            .set(Design.state.textField.invisible)
      }
      set(Design.state.stack.inputContent)
      alignment(.center)
      height(Design.params.buttonHeight)
   }
}

final class IconLabelModel<Design: DesignProtocol>:
   Combos<SComboMR<
      ImageViewModel, LabelModel
   >>
{

   var label: LabelModel { models.right }
   var icon: ImageViewModel { models.main }

   required init() {
      super.init()

      setMain {
         $0
            .size(.square(Grid.x16.value))
      } setRight: {
         $0
            .padLeft(8)
            .font( .systemFont(ofSize: 8, weight: .regular))
            .set(.numberOfLines(0))
            .textColor(Design.color.textInvert)
      }
      alignment(.center)
      height(20)
   }
}
