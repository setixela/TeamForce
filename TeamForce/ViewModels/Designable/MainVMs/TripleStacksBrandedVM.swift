//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import CoreGraphics
import ReactiveWorks

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

   lazy var profileButton = ImageViewModel()
      .set_image(Design.icon.avatarPlaceholder)
      .set_url("https://picsum.photos/200")
      .set_size(.square(Grid.x36.value))
      .set_cornerRadius(Grid.x36.value / 2)
      .set_borderColor(Design.color.backgroundBrandSecondary.withAlphaComponent(0.85))
      .set_borderWidth(3)


   private lazy var topButtonsStack = StackModel()
      .set_axis(.horizontal)
      .set_spacing(Grid.x8.value)
      .set_arrangedModels([
         BrandLogoIcon<Design>(),
         Grid.xxx.spacer,
         ButtonModel()
            .set(Design.state.button.transparent)
            .set(.image(Design.icon.alarm))
            .set_size(.square(Grid.x36.value)),
         profileButton
      ])

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.header)
            .set_alignment(.fill)
            .set_arrangedModels([
               Grid.x1.spacer,
               topButtonsStack,
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

   override func start() {
      profileButton.set(.tapGesturing)
   }
}