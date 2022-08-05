//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

final class LabelModel: BaseViewModel<PaddingLabel> {}

extension LabelModel: Stateable2 {
   typealias State = LabelState
   typealias State2 = ViewState
}
