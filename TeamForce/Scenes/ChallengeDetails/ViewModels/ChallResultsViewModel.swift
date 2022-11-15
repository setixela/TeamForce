//
//  ChallResultsViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallResultViewModel<Design: DSP>: StackModel, Designable {
   
   lazy var resultsTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         ChallResultsPresenters<Design>().resultsCellPresenter,
         SpacerPresenter.presenter
      ]))

   override func start() {
      super.start()
      
      arrangedModels([
         Spacer(8),
         resultsTableModel
      ])
   }
}

extension ChallResultViewModel: SetupProtocol {
   func setup(_ data: [ChallengeResult]) {
      resultsTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
