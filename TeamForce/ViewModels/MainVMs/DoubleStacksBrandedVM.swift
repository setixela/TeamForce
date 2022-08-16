//
//  DoubleStacksBrandedVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation

final class DoubleStacksBrandedVM<Design: DesignProtocol>: Combos<SComboMD<StackModel, WrappedY<StackModel>>>,
                                                           Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.default)
            .set_backColor(Design.color.backgroundBrand)
            .set_alignment(.leading)
            .set_models([
               Grid.x16.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
//            .set(Design.state.stack.bottomShadowedPanel)
            .set_backColor(Design.color.background)
            .set_padding(.top(-Grid.x16.value))
            .set_padBottom(-Grid.x32.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      }
   }
}
