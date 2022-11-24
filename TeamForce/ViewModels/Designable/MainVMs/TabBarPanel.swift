//
//  TabBarPanel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - -----------------

final class TabBarPanel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>, Designable, Stateable {
   typealias State = StackState

   // MARK: - View Models

   let button1: ButtonSelfModable = BottomPanelVMBuilder<Design>.button
      .image(Design.icon.tabBarButton1)
   let button2: ButtonSelfModable = BottomPanelVMBuilder<Design>.button
      .image(Design.icon.tabBarButton2)

   let buttonMain: ButtonSelfModable = BottomPanelVMBuilder<Design>.mainButton

   let button3: ButtonSelfModable = BottomPanelVMBuilder<Design>.button
      .image(Design.icon.tabBarButton3)
   let button4: ButtonSelfModable = BottomPanelVMBuilder<Design>.button
      .image(Design.icon.tablerAward)

   // MARK: - Private

   private let backImage = TabBarBackImageModel<Design>()

   // MARK: - Start

   override func start() {
      safeAreaOffsetDisabled()
      axis(.horizontal)
         .distribution(.equalSpacing)
         .alignment(.bottom)
         .arrangedModels([
            Grid.xxx.spacer,
            button1,
            button2,

            WrappedY(
               buttonMain
            )
            .safeAreaOffsetDisabled()
            .padding(.verticalShift(30.aspectInverted)),
            button3,
            button4,
            Grid.xxx.spacer
         ])

         .padding(.verticalShift(16.aspected))
         .height(97.aspected)
         .backViewModel(backImage)
   }
}

struct BottomPanelVMBuilder<Design: DesignProtocol>: Designable {
   static var mainButton: ButtonSelfModable {
      ButtonSelfModable()
         .safeAreaOffsetDisabled()
         //
         .backColor(Design.color.backgroundBrand)
         .image(Design.icon.tablerBrandTelegram.withTintColor(.white))
         .size(.square(60.aspected))
         .cornerRadius(60/2)
         .shadow(Design.params.panelMainButtonShadow)
   }

   static var button: ButtonSelfModable {
      ButtonSelfModable()
         .safeAreaOffsetDisabled()
         //
         .width(55)
         .height(46)
         .cornerRadius(16)
         .onSelfModeChanged(\.normal) { button in
            button?
               .backColor(Design.color.backgroundBrandSecondary)
               .shadow(Design.params.panelButtonShadow)
            button?.uiView.layoutIfNeeded()
         }
         .onSelfModeChanged(\.inactive) { button in
            button?
               .backColor(Design.color.transparent)
               .shadow(.noShadow)
         }
         .setSelfMode(\.inactive)
   }
}

final class TabBarBackImageModel<Design: DSP>: BaseViewModel<PaddingImageView>, Designable, Stateable2 {
   typealias State = ImageViewState
   typealias State2 = ViewState

   override func start() {
      image(Design.icon.bottomPanel)
      imageTintColor(Design.color.background)
      shadow(Design.params.panelShadow)
   }
}
