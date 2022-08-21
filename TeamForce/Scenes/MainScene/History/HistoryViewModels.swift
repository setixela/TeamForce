//
//  HistoryViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

final class HistoryViewModels<Design: DesignProtocol>: Designable {
   lazy var tableModel = TableItemsModel<Design>()
      .set_backColor(Design.color.background)

   lazy var segmentedControl = SegmentControl<SegmentButton<Design>, SegmentControl3Events>()
      .set(.height(50))
      .set(.items([
         SegmentButton<Design>.withTitle("Вся история"),
         SegmentButton<Design>.withTitle("Получено"),
         SegmentButton<Design>.withTitle("Отправлено"),
      ]))
}




