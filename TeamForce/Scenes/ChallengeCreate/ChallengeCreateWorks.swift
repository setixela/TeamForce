//
//  ChallengeCreateWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import UIKit

protocol ChallengeCreateWorksProtocol {
   var createChallenge: Work<Void, Void> { get }

   var setTitle: Work<String, Void> { get }
   var setDesription: Work<String, Void> { get }
   var setPrizeFund: Work<String, Void> { get }
   var setFinishDate: Work<Date, Date> { get }

   var checkAllReady: Work<Void, Bool> { get }
}

final class ChallengeCreateWorksStore: InitProtocol, ImageStorage {
   var images: [UIImage] = []

   var title: String = ""
   var desription: String = ""
   var prizeFund: String = ""
   var finishDate: Date = .distantFuture
   
   var challengeTypes: [(String, Int)] = []
   var selectedChallengeType = "default"
   
   var showCandidates = "no"
   var severalReports = "no"

//   func clear() {
//      title = ""
//      desription = ""
//      prizeFund = ""
//      images = []
//   }
}

final class ChallengeCreateWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeCreateWorksStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
}

extension ChallengeCreateWorks: ChallengeCreateWorksProtocol {
   var checkAllReady: Work<Void, Bool> { .init { work in
      let ready =
         Self.store.title.isEmpty == false &&
         Self.store.prizeFund.isEmpty == false
      work.success(ready)
   }.retainBy(retainer) }

   var setTitle: Work<String, Void> { .init { work in
      Self.store.title = work.unsafeInput
      work.success()
   }.retainBy(retainer) }

   var setDesription: Work<String, Void> { .init { work in
      Self.store.desription = work.unsafeInput
      work.success()
   }.retainBy(retainer) }

   var setPrizeFund: Work<String, Void> { .init { work in
      Self.store.prizeFund = work.unsafeInput
      work.success()
   }.retainBy(retainer) }

   var setFinishDate: Work<Date, Date> { .init { work in
      Self.store.finishDate = work.unsafeInput
      work.success(work.unsafeInput)
   }.retainBy(retainer) }

   // MARK: - Create chall

   var createChallenge: Work<Void, Void> { .init { [weak self] work in
      let showParticipants = Self.store.selectedChallengeType == "voting" ? nil : Self.store.showCandidates
      let body = ChallengeRequestBody(
         name: Self.store.title,
         description: Self.store.desription,
         endAt: Self.store.finishDate.convertToString(.yearMonthDayDigits),
         startBalance: Int(Self.store.prizeFund).int,
         photo: Self.store.images.first?.resized(to: Config.imageSendSize),
         parameterId: nil,
         parameterValue: nil,
         challengeType: Self.store.selectedChallengeType,
         showParticipants: showParticipants,
         severalReports: Self.store.severalReports
      )
      self?.apiUseCase.createChallenge
         .doAsync(body)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var createChallengeGet: Work<Void, [String]> { .init { [weak self] work in
      self?.apiUseCase.createChallengeGet
         .doAsync()
         .onSuccess {
            var res: [(String, Int)] = []
            if $0.types?.default == 1 {
               res.append(("Обычный", 1))
            }
            if $0.types?.voting == 2 {
               res.append(("Голосование", 2))
            }
            Self.store.challengeTypes = res
            let typeNames = res.map { $0.0 }
            work.success(typeNames)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var changeChallType: Work<Int, String> { .init { work in
      guard let input = work.input else { work.fail(); return }
      if input == 1 {
         Self.store.selectedChallengeType = "voting"
      } else {
         Self.store.selectedChallengeType = "default"
      }
      work.success(Self.store.selectedChallengeType)
   }.retainBy(retainer) }
   
   
   var showCandidatesTurnOn: Work<Void, Void> { .init { work in
      Self.store.showCandidates = "yes"
      work.success()
   }.retainBy(retainer) }
   
   var showCandidatesTurnOff: Work<Void, Void> { .init { work in
      Self.store.showCandidates = "no"
      work.success()
   }.retainBy(retainer) }
   
   var severalReportsTurnOn: Work<Void, Void> { .init { work in
      Self.store.severalReports = "yes"
      work.success()
   }.retainBy(retainer) }
   
   var severalReportsTurnOff: Work<Void, Void> { .init { work in
      Self.store.severalReports = "no"
      work.success()
   }.retainBy(retainer) }
   
   
}

extension ChallengeCreateWorks: ImageWorks {}
