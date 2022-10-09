//
//  ChallengeDetailsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

final class ChallengeDetailsViewModel<Design: DSP>: StackModel, Designable {
   private lazy var challengeInfo = ChallengeInfoVM<Design>()

   override func start() {
      super.start()

      arrangedModels([
         challengeInfo
      ])
   }
}

enum ChallengeDetailsViewModelState {
   case details(Challenge)
}

extension ChallengeDetailsViewModel: StateMachine {
   func setState(_ state: ChallengeDetailsViewModelState) {
      switch state {
      case .details(let challenge):
         challengeInfo.setup(challenge)
      }
   }
}

extension ChallengeDetailsViewModel: SetupProtocol {
   func setup(_ data: Challenge) {
      challengeInfo.setup(data)
   }
}

final class ChallengeInfoVM<Design: DSP>: StackModel, Designable {
   lazy var title = Design.label.title
   lazy var body = Design.label.body1
   lazy var tags = StackModel()

   override func start() {
      super.start()
   }
}

extension ChallengeInfoVM: SetupProtocol {
   func setup(_ data: Challenge) {
      title.text(data.name.string)
      body.text(data.description.string)
      tags.arrangedModels([
         ChallengeStatusBlock<Design>()
            .text("JDSAH askjdha skj"),
         ChallengeStatusBlock<Design>()
            .text("JDSAH askjdha skj")
      ])
   }
}

final class ChallengeStatusBlock<Design: DSP>: LabelModel, Designable {
   override func start() {
      backColor(Design.color.backgroundInfoSecondary)
      height(36)
      cornerRadius(36 / 2)
   }
}
