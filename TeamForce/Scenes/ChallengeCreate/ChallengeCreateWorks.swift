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

//   func clear() {
//      title = ""
//      desription = ""
//      prizeFund = ""
//      images = []
//   }
}

final class ChallengeCreateWorks<Asset: AssetProtocol>: BaseWorks<ChallengeCreateWorksStore, Asset> {
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
      let body = ChallengeRequestBody(
         name: Self.store.title,
         description: Self.store.desription,
         endAt: Self.store.finishDate.convertToString(.yearMonthDayDigits),
         startBalance: Int(Self.store.prizeFund).int,
         photo: Self.store.images.first?.resized(to: Config.imageSendSize),
         parameterId: nil,
         parameterValue: nil
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
}

extension ChallengeCreateWorks: ImageWorks {}
