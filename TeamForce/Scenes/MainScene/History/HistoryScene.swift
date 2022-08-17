//
//  HistoryScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks

// MARK: - HistoryScene

final class HistoryScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   Void
>, Scenaryable {
   //

   lazy var scenario = HistoryScenario(viewModels: HistoryViewModels<Design>(
      tableModel: TableViewModel()
         .set(.borderColor(.gray))
         .set(.borderWidth(1))
         .set(.cornerRadius(Design.params.cornerRadius)),

      segmentedControl: SegmentedControlModel()
         .set(.items(["Все", "Получено", "Отправлено"]))
         .set(.height(50))
         .set(.selectedSegmentIndex(0))

   ), works: HistoryWorks<Asset>())

   // MARK: - Start

   override func start() {
      configure()
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension HistoryScene {
   func configure() {
      mainVM
         .setMain { _ in } setDown: {
            $0.subModel
               .set_models([
                  scenario.vModels.segmentedControl,
                  scenario.vModels.tableModel,
                  Grid.xxx.spacer
               ])
         }
         .header.set_text(Design.Text.title.autorisation)
   }
}
