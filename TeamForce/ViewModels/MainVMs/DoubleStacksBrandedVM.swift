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

   var bottomSubStack: StackModel { models.down.subModel }

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

final class TripleStacksBrandedVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, WrappedY<StackModel>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: StackModel { models.down2.subModel }

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
      } setDown2: {
         $0
            //            .set(Design.state.stack.bottomShadowedPanel)
            .set_backColor(Design.color.backgroundBrand)
//            .set_padding(.top(-Grid.x16.value))
//            .set_padBottom(-Grid.x32.value)
            .set_axis(.horizontal)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      }
   }
}
