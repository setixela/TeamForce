//
//  ChallWinnersViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallWinnersViewModel<Design: DSP>: StackModel, Designable {
   
   var events: EventsStore = .init()
   
   lazy var winnersTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .presenters(
         ChallWinnersPresenters<Design>().winnersCellPresenter,
         SpacerPresenter.presenter
      )

   override func start() {
      super.start()
      
      arrangedModels([
         Spacer(8),
         winnersTableModel
      ])
      
      winnersTableModel.on(\.didSelectRowInt, self) {
         $0.send(\.didSelectWinner, $1)
      }
   }
}

extension ChallWinnersViewModel: SetupProtocol {
   func setup(_ data: [ChallengeWinnerReport]) {
      winnersTableModel.items(data + [SpacerItem(size: Grid.x64.value)])
   }
}

extension ChallWinnersViewModel: Eventable {
   struct Events: InitProtocol {
      var didSelectWinner: Int?
   }
}
