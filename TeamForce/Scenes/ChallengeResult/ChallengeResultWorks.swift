//
//  ChallengeResultWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallengeResultStore: InitProtocol, ImageStorage {
   var images: [UIImage] = []

   var inputReasonText = ""
   var isCorrectReasonInput = false

   var challengeId: Int?
}

final class ChallengeResultWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeResultStore, Asset> {
   private lazy var reasonInputParser = ReasonCheckerModel()
   private lazy var apiUseCase = Asset.apiUseCase

   var saveId: Work<Int, Int> { .init { work in
      guard let id = work.input else { return }
      Self.store.challengeId = id
      work.success(id)
   }.retainBy(retainer) }

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

   var createChallengeReport: Work<Void, Void> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      let report = ChallengeReportBody(challengeId: id,
                                       text: Self.store.inputReasonText,
                                       photo: Self.store.images.first?.resized(to: Config.imageSendSize))
      self?.apiUseCase.CreateChallengeReport
         .doAsync(report)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

// Добавляем Image Works
extension ChallengeResultWorks: ImageWorks {}
