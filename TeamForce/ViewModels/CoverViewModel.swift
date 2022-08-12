//
//  CoverViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.07.2022.
//

import ReactiveWorks
import UIKit

// MARK: - Digital Thanks Cover

final class CoverViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>, Assetable {
   private let titleModel = IconLabelHorizontalModel<Asset>()
      .set(.icon(Design.icon.make(\.logo)))
      .set(.text(Text.title.digitalThanks))

   private let illustrationModel = ImageViewModel()
      .set(.size(.init(width: 242, height: 242)))
      .set(.image(Design.icon.make(\.clapHands)))

   override func start() {
      set(.distribution(.fill))
      set(.alignment(.center))
      set(.axis(.vertical))
      set(.models([
         Spacer(28),
         titleModel,
         illustrationModel,
         Spacer()
      ]))

      titleModel.icon
         .set(.size(.init(width: 48, height: 48)))

      titleModel.label
         .set(.font(Design.font.headline5))
   }
}

extension CoverViewModel: Stateable {
   typealias State = StackState
}
