//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import CoreGraphics
import ReactiveWorks

// MARK: - View Models --------------------------------------------------------------

final class MainScreenVM<Design: DesignProtocol>:
   Combos<SComboMDD<StackModel, WrappedY<StackModel>, TabBarPanel<Design>>>,
   Designable
{

   lazy var header = Design.label.headline5
      .textColor(Design.color.textInvert)
      .padTop(Grid.x16.value)
      .padBottom(Grid.x6.value)
      .height(56)

   var headerStack: StackModel { models.main }
   var bodyStack: StackModel { models.down.subModel }
   var footerStack: TabBarPanel<Design> { models.down2 }

   lazy var notifyButton = ButtonModel()
      .set(Design.state.button.transparent)
      .set(.image(Design.icon.alarm))
      .size(.square(Grid.x36.value))

   lazy var profileButton = ImageViewModel()
      .image(Design.icon.newAvatar)
      .contentMode(.scaleAspectFill)
      .size(.square(Grid.x36.value))
      .cornerRadius(Grid.x36.value / 2)

   private lazy var topButtonsStack = StackModel()
      .axis(.horizontal)
      .spacing(Grid.x8.value)
      .arrangedModels([
         BrandLogoIcon<Design>(),
         Grid.xxx.spacer,
         notifyButton,
         profileButton
      ])

   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.stack.header)
            .alignment(.fill)
            .arrangedModels([
             //x  Grid.x1.spacer,
               topButtonsStack,
               header,
               Grid.x30.spacer
            ])
      } setDown: {
         $0
            .backColor(Design.color.background)
            .padding(.top(-Grid.x16.value))
            .padBottom(-88.aspected)
            .subModel
            .set(Design.state.stack.bodyStackVerticalPadded)
            .safeAreaOffsetDisabled()
      } setDown2: { _ in }
      
   }

   override func start() {
      profileButton.set(.tapGesturing)
   }
}

enum TripleStacksState {
   case hideHeaderTitle
   case presentHeaderTitle
}

extension MainScreenVM: StateMachine {
   func setState(_ state: TripleStacksState) {
      switch state {
      case .hideHeaderTitle:
         header.alpha(0)
         header.hidden(true)
      case .presentHeaderTitle:
         header.hidden(false)
         header.alpha(1)
      }
   }
}

