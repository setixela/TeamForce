//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

final class TripleStacksBrandedVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, WrappedY<TabBarPanel<Design>>>>,
   Designable
{
   lazy var header = Design.label.headline5
      .set_color(Design.color.textInvert)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: TabBarPanel<Design> { models.down2.subModel }

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
            .set_backColor(Design.color.background)
            .set_padding(.top(-Grid.x16.value))
            .set_padBottom(-Grid.x64.value)
            .subModel
            .set(Design.state.stack.bottomShadowedPanel)
      } setDown2: { _ in }
   }
}

struct BottomPanelVMBuilder<Design: DesignProtocol>: Designable {
   static var mainButton: ButtonModel {
      ButtonModel()
         .set_image(Design.icon.tabBarMainButton)
         .set_size(.square(60))
         .set_shadow(.init(
            radius: 8,
            offset: .init(x: 0, y: 10),
            color: Design.color.iconContrast,
            opacity: 0.23
         ))
   }

   static var button: ButtonModel {
      ButtonModel()
         .set_width(55)
         .set_height(46)
         .set_cornerRadius(16)
         .onModeChanged(\.normal) { button in
            button?
               .set_backColor(Design.color.backgroundBrandSecondary)
               .set_shadow(.init(
                  radius: 8,
                  offset: .init(x: 0, y: 10),
                  color: Design.color.iconContrast,
                  opacity: 0.23
               ))
         }
         .onModeChanged(\.inactive) { button in
            button?
               .set_backColor(Design.color.transparent)
               .set_shadow(.noShadow)
         }
         .setMode(\.inactive)
   }
}
