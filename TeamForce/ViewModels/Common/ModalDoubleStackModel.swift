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
      padding(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
      cornerRadius(Design.params.cornerRadiusMedium)
      shadow(.init(radius: 50, color: Design.color.iconContrast, opacity: 0.33))
      disableBottomRadius(Design.params.cornerRadiusMedium)

      set(.axis(.vertical))
      set(.alignment(.fill))
      set(.distribution(.fill))
      set(.arrangedModels([
         titlePanel,
         bodyStack,
         footerStack
      ]))
   }
}
