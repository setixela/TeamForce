//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactScenarioEvents {
   let userSearchTXTFLDBeginEditing: VoidWork<String>
   let userSearchTFDidEditingChanged: VoidWork<String>
   let userSelected: VoidWork<Int>
   let sendButtonEvent: VoidWork<Void>

   let amountInputChanged: VoidWork<String>
   let reasonInputChanged: VoidWork<String>

   let anonymousSetOff: VoidWork<Void>
   let anonymousSetOn: VoidWork<Void>

   let presentTagsSelectorDidTap: VoidWorkVoid
   let enableTags: VoidWorkVoid
   let disableTags: VoidWorkVoid

   let setTags: VoidWork<Set<Tag>>

   let cancelButtonDidTap: VoidWorkVoid
}

final class TransactScenario<Asset: AssetProtocol>:
   BaseScenario<TransactScenarioEvents, TransactState, TransactWorks<Asset>>
{
   override func start() {
      works.reset.doSync()

      // load token, balance, userList
      works.loadTokens
         .doAsync()
         .onSuccess(setState, .loadTokensSuccess)
         .onFail(setState, .error)
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess(setState) { .loadBalanceSuccess($0.distr.amount) }
         .onFail(setState, .error)
         // then break to void and load 10 user list
         .doVoidNext(works.getUserList)
         .onSuccess(setState) { .loadUsersListSuccess($0) }
         .onFail(setState, .error)

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
         .onFail(setState) { .error }

      events.userSelected
         .doSaveResult()
         .doNext(work: works.mapIndexToUser)
         .onSuccessMixSaved(setState) { .userSelectedSuccess($0, $1) }

      events.sendButtonEvent
         .onSuccess(setState, .sendButtonPressed)
         .doNext(work: works.sendCoins)
         .onSuccess(setState) { .sendCoinSuccess($0) }
         .onFail(setState, .sendCoinError)
         .doVoidNext(works.reset)

      events.amountInputChanged
         .doNext(work: works.coinInputParsing)
         .onSuccess(setState) { .coinInputSuccess($0, true) }
         .onFail { [weak self] (text: String) in
            self?.setState(.resetCoinInput)
            self?.works.updateAmount
               .doAsync((text, false))
               .onSuccess(self?.setState) { .coinInputSuccess(text, false) }
         }
         .doRecover()
         .doSaveResult() // save text
         .doMap { ($0, true) }
         .doNext(work: works.updateAmount)
         .doNext(work: works.isCorrectBothInputs)
         .onSuccessMixSaved(setState) { _, savedText in
            .coinInputSuccess(savedText, true)
         }
         .onFailMixSaved(setState) { _, savedText in
            .coinInputSuccess(savedText, false)
         }

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
         .doNext(work: works.isCorrectBothInputs)
         .onSuccessMixSaved(setState) { .reasonInputSuccess($1, true) }
         .onFailMixSaved(setState) { .reasonInputSuccess($1, false) }

      events.anonymousSetOff
         .doNext(work: works.anonymousOff)

      events.anonymousSetOn
         .doNext(work: works.anonymousOn)

      events.cancelButtonDidTap
         .onSuccess(setState, .cancelButtonPressed)

      events.enableTags
         .doInput(true)
         .doNext(work: works.enableTags)

      events.disableTags
         .doInput(false)
         .doNext(work: works.enableTags)

      events.setTags
         .doNext(work: works.setTags)
         .doNext(work: works.getSelectedTags)
         .onSuccess(setState) {
            .updateSelectedTags($0)
         }

      events.presentTagsSelectorDidTap
         .doNext(work: works.getSelectedTags)
         .onSuccess(setState) { .presentTagsSelector($0) }
   }
}
