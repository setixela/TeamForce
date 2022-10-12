//
//  ChallengeResultWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks

final class ChallengeResultStore: InitProtocol {
   var inputReasonText = ""
   var isCorrectReasonInput = false
}

final class ChallengeResultWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeResultStore, Asset> {
   private lazy var reasonInputParser = ReasonCheckerModel()

   var reasonInputParsing: Work<String, String> { .init { [weak self] work in
      self?.reasonInputParser.work
         .retainBy(self?.retainer)
         .doAsync(work.input)
         .onSuccess {
            Self.store.inputReasonText = $0
            Self.store.isCorrectReasonInput = true
            work.success(result: $0)
         }
         .onFail { (text: String) in
            Self.store.inputReasonText = ""
            Self.store.isCorrectReasonInput = false
            work.fail(text)
         }
   } }
}
