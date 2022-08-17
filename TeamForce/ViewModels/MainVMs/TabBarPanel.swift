//
//  TabBarPanel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

final class TabBarPanel<Design: DesignProtocol>: BaseViewModel<UIStackView>, Designable, Stateable {
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

   // MARK: - Start

   override func start() {
      set_axis(.horizontal)
         .set_distribution(.equalSpacing)
         .set_alignment(.bottom)
         .set_models([
            Grid.xxx.spacer,
            button1,
            button2,

            WrappedY(
               buttonMain
            )
            .set_padding(.verticalShift(23)),

            button3,
            button4,
            Grid.xxx.spacer
         ])

         .set_shadow(.init(
            radius: 8, color: Design.color.iconContrast, opacity: 0.13
         ))
         .set_padding(.verticalShift(13))
         .set_height(88)
         .set_backImage(Design.icon.bottomPanel, contentMode: .scaleToFill)
   }
}
