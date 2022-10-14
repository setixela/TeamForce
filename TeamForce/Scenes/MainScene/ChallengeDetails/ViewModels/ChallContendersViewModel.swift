//
//  ChallContendersViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallContendersViewModel<Design: DSP>: StackModel, Designable {
   
   lazy var contendersTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         ChallContendersPresenters<Design>().contendersCellPresenter,
         SpacerPresenter.presenter
      ]))

   override func start() {
      super.start()
      
      arrangedModels([
         Spacer(8),
         contendersTableModel
      ])
   }
}

extension ChallContendersViewModel: SetupProtocol {
   func setup(_ data: [Contender]) {
      contendersTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
