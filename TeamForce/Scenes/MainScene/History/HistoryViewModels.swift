//
//  HistoryViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 17.08.2022.
//

import Foundation

final class HistoryViewModels<Design: DesignProtocol>: Designable {
   lazy var tableModel = TableItemsModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.params.cornerRadius))

   lazy var segmentedControl = SegmentedControlModel()
      .set(.items(["Все", "Получено", "Отправлено"]))
      .set(.height(50))
      .set(.selectedSegmentIndex(0))
}
