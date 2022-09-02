//
//  LabelSwitcher.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

class LabelSwitcherX: Combos<SComboMR<LabelModel, WrappedY<Switcher>>> {
   var label: LabelModel { models.main }
   var switcher: Switcher { models.right.subModel }

   override func start() {
      alignment(.center)
      axis(.horizontal)

      setAll { _, _ in }
   }
}

extension LabelSwitcherX {
   static func switcherWith(text: String) -> Self {
      Self()
         .setAll { label, _ in
            label.text(text)
         }
   }
}



