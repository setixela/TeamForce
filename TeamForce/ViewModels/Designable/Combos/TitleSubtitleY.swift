//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleY<Design: DesignProtocol>:
   Combos<SComboMD<LabelModel, LabelModel>>,
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
            .set(.textColor(Design.color.textSecondary))
            .set(.numberOfLines(0))
            .set(.alignment(.center))
           // .set(.padUp(Design.params.titleSubtitleOffset))
      }
   }
}

class TitleSubtitleTextFieldY<Design: DesignProtocol>:
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
            //.placeholder()
      }
   }
}
