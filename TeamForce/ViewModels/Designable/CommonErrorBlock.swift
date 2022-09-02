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
      alignment(.center)
      arrangedModels([
         ImageViewModel()
            .image(Design.icon.errorIllustrate)
            .size(.square(220)),
         Grid.x20.spacer,
         Design.label.body1
            .text(Design.Text.title.loadPageError),
         Grid.x20.spacer,
         Design.label.default
            .text(Design.Text.title.connectionError),
         Grid.xxx.spacer
      ])
   }
}
