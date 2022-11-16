//
//  HistoryViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct HistoryViewModels<Design: DesignProtocol>: Designable {
   lazy var tableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)

   lazy var segmentedControl = SegmentControl<SegmentButton<Design>, SegmentControl3Events>()
      .set(.height(Grid.x40.value))
      .set(.items([
         SegmentButton<Design>.withTitle("Вся история"),
         SegmentButton<Design>.withTitle("Получено"),
         SegmentButton<Design>.withTitle("Отправлено"),
      ]))
      .set(.selected(0))
   
   lazy var presenter = HistoryPresenters<Design>()
}
