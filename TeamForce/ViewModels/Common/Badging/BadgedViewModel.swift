//
//  BadgedViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - New

enum TopBadgerState {
   case badgeState(ViewState)
   case badgeLabelStates([LabelState])
   case presentBadge(String)
   case hideBadge
}

final class TopBadger<VM: VMPS>: Combos<SComboMD<WrappedY<LabelModel>, VM>> {

   var mainModel: VM { models.down }

   required init() {
      super.init()

      setAll { topBadge, model in
         topBadge
            .padding(.verticalShift(-7.5))
            .padLeft(Grid.x16.value)
            .zPosition(1000)
            .alignment(.leading)
      }
   }
}

extension TopBadger: Stateable2 {
   func applyState(_ state: TopBadgerState) {
      switch state {
      case .badgeState(let value):
         models.main.subModel.set(value)
      case .badgeLabelStates(let value):
         models.main.subModel.set(value)
      case .presentBadge(let value):
         models.main.subModel.text(value)
      case .hideBadge:
         models.main.subModel.text("")
      }
   }
}

