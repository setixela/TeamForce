//
//  TitleBodySwitcherDT.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks

final class TitleBodySwitcherDT<Design: DSP>: TitleBodySwitcherY {
   override func start() {
      super.start()

      padding(Design.params.contentPadding)

      setAll { title, _ in
         title
            .set(Design.state.label.caption)
            .textColor(Design.color.textSecondary)

      }
   }
}
