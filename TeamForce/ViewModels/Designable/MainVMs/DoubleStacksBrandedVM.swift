//
//  DoubleStacksBrandedVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation

final class BrandDoubleStackVM<Design: DesignProtocol>: Combos<SComboMD<StackModel, WrappedY<StackModel>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .textColor(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.default)
            .backColor(Design.color.backgroundBrand)
            .alignment(.leading)
            .arrangedModels([
               Grid.x8.spacer
            ])
      } setDown: {
         $0
            .backColor(Design.color.background)
            .padding(.top(-Grid.x16.value))
            .padBottom(-Grid.x32.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      }
   }
}

final class DoubleStacksBrandedVM<Design: DesignProtocol>: Combos<SComboMD<StackModel, WrappedY<StackModel>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .textColor(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.default)
            .backColor(Design.color.backgroundBrand)
            .alignment(.leading)
            .arrangedModels([
               Grid.x16.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
            .backColor(Design.color.background)
            .padding(.top(-Grid.x16.value))
            .padBottom(-Grid.x32.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      }
   }
}

final class TripleStacksBrandedVM<Design: DesignProtocol>: Combos<SComboMDD<StackModel, WrappedY<StackModel>, StackModel>>,
   Designable
{
   lazy var header = Design.label.headline5
      .textColor(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: StackModel { models.down2 }

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.default)
            .backColor(Design.color.backgroundBrand)
            .alignment(.leading)
            .arrangedModels([
               Grid.x16.spacer,
               BrandLogoIcon<Design>(),
               Grid.x16.spacer,
               header,
               Grid.x36.spacer
            ])
      } setDown: {
         $0
            .backColor(Design.color.background)
            .padding(.top(-Grid.x16.value))
            .padBottom(-Grid.x32.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      } setDown2: {
         $0
            .backColor(Design.color.background)
            .padding(.top(-Grid.x16.value))
            .padBottom(-Grid.x32.value)
            .set(Design.state.stack.bottomPanel)
      }
   }
}
