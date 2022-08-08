//
//  TitleSubtitleModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - TitleSubtitleModel

final class TitleSubtitleModel: BaseViewModel<PaddingLabel>, Stateable2 {
   typealias State = ViewState
   typealias State2 = LabelState
   //
   let downModel: LabelModel = .init()
//
}

extension TitleSubtitleModel: ComboDown {
   typealias DownModel = LabelModel
}
