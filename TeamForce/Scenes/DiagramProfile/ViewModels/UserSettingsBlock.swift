//
//  UserSettingsBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserSettingsBlock

final class UserSettingsBlock<Design: DSP>: ProfileStackModel<Design> {
   override func start() {
      super.start()

      axis(.horizontal)
      alignment(.center)
      arrangedModels(
         LabelModel()
            .set(Design.state.label.body1)
            .text("Настройки"),
         Spacer(),
         ImageViewModel()
            .size(.square(24))
            .image(Design.icon.tablerSettings, color: Design.color.iconContrast)
      )
   }
}
