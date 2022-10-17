//
//  ModalDoubleStackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

import ReactiveWorks
import UIKit

class ModalDoubleStackModel<Asset: AssetProtocol>: DoubleStacksModel, Assetable {
   let title = LabelModel()
      .set(Design.state.label.body3)
      .alignment(.center)
   let closeButton = ButtonModel()
      .title(Design.Text.title.close)
      .textColor(Design.color.textBrand)

   private lazy var titlePanel = Wrapped3X(
      Spacer(50),
      title,
      closeButton
   )
   .height(64)
   .alignment(.center)
   .distribution(.equalCentering)

   override func start() {
      backColor(Design.color.background)
      cornerRadius(Design.params.cornerRadiusMedium)
      shadow(.init(radius: 50, color: Design.color.iconContrast, opacity: 0.33))
      padding(UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))

      axis(.vertical)
      alignment(.fill)
      distribution(.fill)
      arrangedModels([
         titlePanel,
         bodyStack,
         footerStack
      ])
      disableBottomRadius(Design.params.cornerRadiusMedium)
   }
}
