//
//  ChallengeDetailsScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.10.2022.
//

import ReactiveWorks

final class ChallengeDetailsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   TripleStacksModel,
   Asset,
   Challenge
>, Scenarible {
   lazy var scenario: Scenario = ChallengeDetailsScenario(
      works: ChallengeDetailsWorks<Asset>(),
      stateDelegate: setState,
      events: ChallengeDetailsInputEvents()
   )

   private var filteButtons = SlidedIndexButtons<Button3Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Детали")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Комментарии")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Участники")
         .font(Design.font.default))

   private var viewModel = ChallengeDetailsViewModel<Design>()

   override func start() {
      super.start()

      mainVM.headerStack
         .backColor(Design.color.backgroundBrandSecondary)
         .height(200)
         .padding(.verticalOffset(16))
         .arrangedModels([
            ImageViewModel()
               .image(Design.icon.challengeWinnerIllustrate)
               .contentMode(.scaleAspectFit)
         ])

      mainVM.bodyStack
         .padding(.init(
            top: 24,
            left: Design.params.commonSideOffset,
            bottom: 16,
            right: Design.params.commonSideOffset
         ))
         .arrangedModels([
            filteButtons
         ])

      mainVM.footerStack
         .arrangedModels([
            viewModel
         ])

      on(\.input, self) {
         $0.viewModel.setState(.details($1))
      }
   }
}

enum ChallengeDetailsState {
   case initial
}

extension ChallengeDetailsScene: StateMachine {
   func setState(_ state: ChallengeDetailsState) {}
}
