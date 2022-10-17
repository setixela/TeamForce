//
//  TitleBodySwitcher.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

class TitleBodySwitcherY: Combos<SComboMD<LabelModel, LabelSwitcherX>> {
   var title: LabelModel { models.main }
   var body: LabelModel { models.down.label }
   var switcher: Switcher { models.down.switcher }

   override func start() {
      setAll { _, _ in }

      axis(.vertical)
   }
}

extension TitleBodySwitcherY {
   static func switcherWith(titleText: String, bodyText: String) -> Self {
      Self()
         .setAll { title, bodySwitcher in
            title.text(titleText)
            bodySwitcher.label.text(bodyText)
         }
   }
}
