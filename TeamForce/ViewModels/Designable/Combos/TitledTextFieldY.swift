//
//  TitledTextFieldY.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

class TitledTextFieldY<Design: DesignProtocol>:
   Combos<SComboMD<LabelModel, TextFieldModel>>,
   Designable
{
   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.label.title)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .textColor(Design.color.textSecondary)
            .clearButtonMode(.never)
      }
   }
}
