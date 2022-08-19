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

   let button1: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton1)
   let button2: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton2)

   let buttonMain: ButtonModel = BottomPanelVMBuilder<Design>.mainButton

   let button3: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton3)
   let button4: ButtonModel = BottomPanelVMBuilder<Design>.button
      .set_image(Design.icon.tabBarButton4)

   // MARK: - Private

   private let backImage = TabBarBackImageModel<Design>()

   // MARK: - Start

   override func start() {
      set_safeAreaOffsetDisabled()
      set_axis(.horizontal)
         .set_distribution(.equalSpacing)
         .set_alignment(.bottom)
         .set_arrangedModels([
            Grid.xxx.spacer,
            button1,
            button2,

            WrappedY(
               buttonMain
            )
            .set_safeAreaOffsetDisabled()
            .set_padding(.verticalShift(30.aspectInverted)),
            button3,
            button4,
            Grid.xxx.spacer
         ])

         .set_padding(.verticalShift(16.aspected))
         .set_height(97.aspected)
         .set_backViewModel(backImage)
   }
}

struct BottomPanelVMBuilder<Design: DesignProtocol>: Designable {
   static var mainButton: ButtonModel {
      ButtonModel()
         .set_safeAreaOffsetDisabled()
         //
         .set_backImage(Design.icon.tabBarMainButton)
         .set_size(.square(60.aspected))
         .set_shadow(Design.params.panelMainButtonShadow)
   }

   static var button: ButtonModel {
      ButtonModel()
         .set_safeAreaOffsetDisabled()
         //
         .set_width(55)
         .set_height(46)
         .set_cornerRadius(16)
         .onModeChanged(\.normal) { button in
            log("sh")
            button?
               .set_backColor(Design.color.backgroundBrandSecondary)
               .set_shadow(Design.params.panelButtonShadow)
            button?.uiView.layoutIfNeeded()
         }
         .onModeChanged(\.inactive) { button in
            button?
               .set_backColor(Design.color.transparent)
               .set_shadow(.noShadow)
         }
         .setMode(\.inactive)
   }
}

final class TabBarBackImageModel<Design: DSP>: BaseViewModel<PaddingImageView>, Designable, Stateable2 {
   typealias State = ImageViewState
   typealias State2 = ViewState

   override func start() {
      set_image(Design.icon.bottomPanel)
      set_imageTintColor(Design.color.background)
      set_shadow(Design.params.panelShadow)
   }
}
