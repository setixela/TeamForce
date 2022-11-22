//
//  ChallReportDetailsWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallReportDetailsStore: InitProtocol {
   var report: ChallengeReport?
}

final class ChallReportDetailsWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallReportDetailsStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase

   var getChallengeReportById: Work<Int, ChallengeReport> { .init { [weak self] work in
      guard let id = work.input else { return }
      self?.apiUseCase.getChallengeReport
         .doAsync(id)
         .onSuccess {
            Self.store.report = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
