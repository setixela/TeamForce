//
//  ChallReportDetailsScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import ReactiveWorks

final class ChallReportDetailsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Int
>, Scenarible {
//
   private let works = ChallReportDetailsWorks<Asset>()

   lazy var scenario: Scenario = ChallReportDetailsScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate,
      events: ChallReportDetailsEvents(
         saveInput: on(\.input)
      )
   )


   private lazy var viewModel = ChallReportDetailsVM<Design>()

   lazy var viewModelsWrapper = ScrollViewModelY()
      .set(.spacing(Grid.x16.value))
      .set(.arrangedModels([
         viewModel.photo,
         viewModel.title,
         viewModel.body,
         Grid.x48.spacer
      ]))

   override func start() {
      super.start()

      mainVM.title
         .text("Результат")

      mainVM.bodyStack
         .arrangedModels([
            ScrollViewModelY()
               .set(.arrangedModels([
                  viewModel.photo,
                  Spacer(12),
                  viewModel.title,
                  Spacer(12),
                  viewModel.body,
               ]))
         ])
      
      mainVM.footerStack
         .arrangedModels([
            Spacer(6)
         ])
         .padding(.top(Grid.x16.value))
         .padBottom(Grid.x16.value)

      mainVM.closeButton
         .on(\.didTap, self) {
            $0.vcModel?.dismiss(animated: true)
            $0.finisher?(true)
         }

      scenario.start()
   }
}

enum ChallReportDetailsSceneState {
   case initial
   case presentReportDetail(ChallengeReport)

   case popScene
   case finish
}

extension ChallReportDetailsScene: StateMachine {
   func setState(_ state: ChallReportDetailsSceneState) {
      switch state {
      case .initial:
         break
      case .presentReportDetail(let value):
         viewModel.setup(value)
      case .popScene:
         vcModel?.dismiss(animated: true)
      case .finish:
         vcModel?.dismiss(animated: true)
         finisher?(false)
      }
   }
}
