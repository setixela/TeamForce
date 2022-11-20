//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactScenarioEvents {
   let userSearchTXTFLDBeginEditing: WorkVoid<String>
   let userSearchTFDidEditingChanged: WorkVoid<String>
   let userSelected: WorkVoid<Int>
   let sendButtonEvent: WorkVoid<Void>

   let amountInputChanged: WorkVoid<String>
   let reasonInputChanged: WorkVoid<String>

   let anonymousSetOff: WorkVoid<Void>
   let anonymousSetOn: WorkVoid<Void>

   let presentTagsSelectorDidTap: WorkVoidVoid
   let enableTags: WorkVoidVoid
   let disableTags: WorkVoidVoid
   let removeTag: WorkVoid<Tag>

   let setTags: WorkVoid<Set<Tag>>

   let cancelButtonDidTap: WorkVoidVoid
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
         .doNext(works.loadBalance)
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
         .doNext(works.mapIndexToUser)
         .onSuccessMixSaved(setState) { .userSelectedSuccess($0, $1) }

      events.sendButtonEvent
         .onSuccess(setState, .sendButtonPressed)
         .doNext(works.sendCoins)
         .onSuccess(setState) { .sendCoinSuccess($0) }
         .onFail(setState, .sendCoinError)
         .doVoidNext(works.reset)

      events.amountInputChanged
         .doNext(works.coinInputParsing)
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
         .doNext(works.updateAmount)
         .doNext(works.isCorrectBothInputs)
         .onSuccessMixSaved(setState) { _, savedText in
            .coinInputSuccess(savedText, true)
         }
         .onFailMixSaved(setState) { _, savedText in
            .coinInputSuccess(savedText, false)
         }

      events.reasonInputChanged
         .doNext(works.reasonInputParsing)
         .onFail { [weak self] (text: String) in
            self?.works.updateReason
               .doAsync((text, false))
               .onSuccess(self?.setState, .reasonInputSuccess(text, false))
         }
         .doRecover()
         .doSaveResult()
         .doMap { ($0, true) }
         .doNext(works.updateReason)
         .doNext(works.isCorrectBothInputs)
         .onSuccessMixSaved(setState) { .reasonInputSuccess($1, true) }
         .onFailMixSaved(setState) { .reasonInputSuccess($1, false) }

      events.anonymousSetOff
         .doNext(works.anonymousOff)

      events.anonymousSetOn
         .doNext(works.anonymousOn)

      events.cancelButtonDidTap
         .onSuccess(setState, .cancelButtonPressed)

      events.enableTags
         .doInput(true)
         .doNext(works.enableTags)

      events.disableTags
         .doInput(false)
         .doNext(works.enableTags)

      events.setTags
         .doNext(works.setTags)
         .doNext(works.getSelectedTags)
         .doSaveResult()
         .doVoidNext(works.isCorrectBothInputs)
         .onSuccessMixSaved(setState) { .updateSelectedTags($1, true) }
         .onFailMixSaved(setState) { .updateSelectedTags($1, false) }

//      events.removeTag
//         .doNext(works.removeTag)
//         .doNext(works.getSelectedTags)
//         .onSuccess(setState) {
//            .updateSelectedTags($0)
//         }

      events.presentTagsSelectorDidTap
         .doNext(works.getSelectedTags)
         .onSuccess(setState) { .presentTagsSelector($0) }
   }
}
