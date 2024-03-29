//
//  DoubleLabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

final class DoubleLabelModel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Designable
{
   lazy var labelLeft = Design.label.body2
   lazy var labelRight = Design.label.body2

   override func start() {
      set(.axis(.horizontal))
         .set(.cornerRadius(Design.params.cornerRadius))
         .set(.distribution(.fill))
         .set(.alignment(.fill))
         .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
         .set(.arrangedModels([
            labelLeft,
            Spacer(),
            labelRight
         ]))
   }
}

extension DoubleLabelModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}

