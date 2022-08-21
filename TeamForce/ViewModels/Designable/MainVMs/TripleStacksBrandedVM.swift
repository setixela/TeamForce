//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import CoreGraphics


// MARK: - View Models --------------------------------------------------------------

final class TripleStacksBrandedVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, TabBarPanel<Design>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: TabBarPanel<Design> { models.down2 }

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.header)
            .set_alignment(.leading)
            .set_arrangedModels([
               Grid.x1.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
            .set_backColor(Design.color.background)
            .set_padding(.top(-Grid.x16.value))
            .set_padBottom(-88.aspected)
            .subModel
            .set(Design.state.stack.bodyStack)
      } setDown2: { _ in }
   }
}


