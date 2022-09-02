//
//  CommonErrorBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import Foundation
import ReactiveWorks

final class CommonErrorBlock<Design: DSP>: StackModel {
   override func start() {
      set_alignment(.center)
      set_arrangedModels([
         ImageViewModel()
            .set_image(Design.icon.errorIllustrate)
            .set_size(.square(220)),
         Grid.x20.spacer,
         Design.label.body1
            .set_text(Design.Text.title.loadPageError),
         Grid.x20.spacer,
         Design.label.default
            .set_text(Design.Text.title.connectionError),
         Grid.xxx.spacer
      ])
   }
}
