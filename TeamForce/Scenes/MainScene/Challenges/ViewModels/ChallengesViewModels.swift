//
//  ChallengesViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import Foundation
import ReactiveWorks

final class ChallengesViewModel<Design: DSP>: StackModel, Designable, Eventable {
   struct Events: InitProtocol {
      var didSelectChallenge: Int?
   }

   var events: EventsStore = .init()

   lazy var challengesTable = TableItemsModel<Design>()
      .set(.presenters([
         ChallengeCellPresenters<Design>.presenter,
         SpacerPresenter.presenter,
      ]))

   override func start() {
      super.start()

      arrangedModels([
         challengesTable,
      ])

      challengesTable
         .on(\.didSelectRowInt, self) {
            $0.send(\.didSelectChallenge, $1)
         }
   }
}

enum ChallengesViewModelState {
   case presentChallenges([Challenge])
}

extension ChallengesViewModel: StateMachine {
   func setState(_ state: ChallengesViewModelState) {
      switch state {
      case .presentChallenges(let challenges):
         challengesTable.set(.items(challenges + [SpacerItem(size: 96)]))
      }
   }
}
