//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct ImagePickingScenarioEvents {
   let addImageToBasket: VoidWork<UIImage>
   let removeImageFromBasket: VoidWork<UIImage>
   let didMaximumReach: VoidWork<Void>
}

final class ImagePickingScenario<Asset: AssetProtocol>:
   BaseScenario<ImagePickingScenarioEvents, TransactState, TransactWorks<Asset>>
{
   override func start() {
      events.addImageToBasket
         .doNext(work: works.addImage)
         .onSuccess(setState) { .presentPickedImage($0) }

      events.removeImageFromBasket
         .doNext(work: works.removeImage)
         .onSuccess(setState, .setHideAddPhotoButton(false))

      events.didMaximumReach
         .onSuccess(setState, .setHideAddPhotoButton(true))
   }
}

struct TransactScenarioEvents {
   let userSearchTXTFLDBeginEditing: VoidWork<String>
   let userSearchTFDidEditingChanged: VoidWork<String>
   let userSelected: VoidWork<Int>
   let sendButtonEvent: VoidWork<Void>

   let transactInputChanged: VoidWork<String>
   let reasonInputChanged: VoidWork<String>

   let anonymousSetOff: VoidWork<Void>
   let anonymousSetOn: VoidWork<Void>
}

final class TransactScenario<Asset: AssetProtocol>:
   BaseScenario<TransactScenarioEvents, TransactState, TransactWorks<Asset>>
{
   override func start() {
      // load token, balance, userList
      works.loadTokens
         .doAsync()
         .onSuccess(setState, .loadTokensSuccess)
         .onFail(setState, .loadTokensError)
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess(setState) { .loadBalanceSuccess($0.distr.amount) }
         .onFail(setState, .loadBalanceError)
         // then break to void and load 10 user list
         .doVoidNext(works.getUserList)
         .onSuccess(setState) { .loadUsersListSuccess($0) }
         .onFail(setState, .loadUsersListError)

      events.userSearchTXTFLDBeginEditing
         .doNext(usecase: IsEmpty())
         .doVoidNext(works.getUserList)
         .onSuccess(setState) { .presentFoundUser($0) }

      // on input event, then check input is not empty, then search user
      events.userSearchTFDidEditingChanged
         .onSuccess(setState, .userSearchTFDidEditingChangedSuccess)
         .doNext(usecase: IsEmpty())
         .onSuccess { [weak self] in
            self?.works.getUserList
               .doAsync()
               .onSuccess(self?.setState) { .presentUsers($0) }
         }
         .doRecover(works.searchUser)
         .onSuccess(setState) { .listOfFoundUsers($0) }
         .onFail(setState) { .loadUsersListError }

      events.userSelected
         .doSaveResult()
         .doNext(work: works.mapIndexToUser)
         .onSuccessMixSaved(setState) { .userSelectedSuccess($0, $1) }

      events.sendButtonEvent
         .doNext(work: works.sendCoins)
         .onSuccess(setState) { .sendCoinSuccess($0) }
         .onFail(setState, .sendCoinError)
         .doVoidNext(works.reset)

      events.transactInputChanged
         .doNext(work: works.coinInputParsing)
         .onSuccess(setState) { .coinInputSuccess($0, true) }
         .onFail { [weak self] (text: String) in
            self?.works.updateAmount
               .doAsync((text, false))
               .onSuccess(self?.setState) { .coinInputSuccess(text, false) }
         }
         .doRecover()
         .doSaveResult() // save inputString
         .doMap { ($0, true) }
         .doNext(work: works.updateAmount)
         .doNext(work: works.isCorrect)
         .onSuccessMixSaved(setState) { .coinInputSuccess($1, true) }
         .onFailMixSaved(setState) { .coinInputSuccess($1, false) }

      events.reasonInputChanged
         .doNext(work: works.reasonInputParsing)
         .onFail { [weak self] (text: String) in
            self?.works.updateReason
               .doAsync((text, false))
               .onSuccess(self?.setState, .reasonInputSuccess(text, false))
         }
         .doRecover()
         .doSaveResult()
         .doMap { ($0, true) }
         .doNext(work: works.updateReason)
         .doNext(work: works.isCorrect)
         .onSuccessMixSaved(setState) { .reasonInputSuccess($1, true) }
         .onFailMixSaved(setState) { .reasonInputSuccess($1, false) }

      events.anonymousSetOff
         .doNext(work: works.anonymousOff)

      events.anonymousSetOn
         .doNext(work: works.anonymousOn)
   }
}
