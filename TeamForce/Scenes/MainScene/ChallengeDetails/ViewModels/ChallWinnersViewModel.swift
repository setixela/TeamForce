//
//  ChallWinnersViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallWinnersViewModel<Design: DSP>: StackModel, Designable {
   
   lazy var winnersTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         ChallWinnersPresenters<Design>().winnersCellPresenter,
         SpacerPresenter.presenter
      ]))

   override func start() {
      super.start()
      
      arrangedModels([
         Spacer(8),
         winnersTableModel
      ])
   }
}

extension ChallWinnersViewModel: SetupProtocol {
   func setup(_ data: [ChallengeWinner]) {
      winnersTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
