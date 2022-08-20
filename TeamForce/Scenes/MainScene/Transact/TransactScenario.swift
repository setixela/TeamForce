//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import Foundation
import ReactiveWorks

struct TransactScenarioEvents {
   let userSearchTXTFLDBeginEditing: VoidWork<String>
   let userSearchTFDidEditingChanged: VoidWork<String>
   let userSelected: VoidWork<IndexPath>
   let sendButtonEvent: VoidWork<Void>

   let transactInputChanged: VoidWork<String>
   let reasonInputChanged: VoidWork<String>
}

protocol ModelState {}

enum TransactState: ModelState {
   case loadProfilError
   case loadTransactionsError

   case loadTokensSuccess
   case loadTokensError

   case loadBalanceSuccess(Int)
   case loadBalanceError

   case loadUsersListSuccess([FoundUser])
   case loadUsersListError

   case presentFoundUser([FoundUser])
   case emptyUserSearchTF([FoundUser])
   case listOfFoundUsers([FoundUser])

   case userSelectedSuccess(FoundUser)

   case userSearchTFDidEditingChangedSuccess

   case sendCoinSuccess((String, SendCoinRequest))
   case sendCoinError

   case coinInputSuccess(String, Bool)
   case reasonInputSuccess(String, Bool)
}

final class TransactScenario<Asset: AssetProtocol>:
   BaseScenario<TransactScenarioEvents, TransactState, TransactWorks<Asset>>
{
   override func start() {
      weak var slf = self

      works.loadTokens
         .doAsync()
         .onSuccess(setState, .loadTokensSuccess)
         .onFail(setState, .loadTokensError)
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess(setState) { .loadBalanceSuccess($0.distr.amount) }
         .onFail(setState, .loadBalanceError)
         // then break to void and load 10 user list
         .doNext(works.getUserList)
         .onSuccess(setState) { .loadUsersListSuccess($0) }
         .onFail(setState, .loadUsersListError)

      events.userSearchTXTFLDBeginEditing
         .doNext(usecase: IsEmpty())
         .doNext(works.getUserList)
         .onSuccess(setState) { .presentFoundUser($0) }

      // on input event, then check input is not empty, then search user
      events.userSearchTFDidEditingChanged
         .onSuccess(setState, .userSearchTFDidEditingChangedSuccess)
         .doNext(usecase: IsEmpty())
         .onSuccess {
            slf?.works.getUserList
               .doAsync()
               .onSuccess(slf?.setState) { .emptyUserSearchTF($0) }
         }
         .doRecover(works.searchUser)
         .onSuccess(setState) { .listOfFoundUsers($0) }

      events.userSelected
         .doNext(work: works.mapIndexToUser)
         .onSuccess(setState) { .userSelectedSuccess($0) }

      events.sendButtonEvent
         .doNext(work: works.sendCoins)
         .onSuccess(setState) { .sendCoinSuccess($0) }
         .onFail(setState, .sendCoinError)
         .doNext(works.reset)

      events.transactInputChanged
         .doNext(work: works.coinInputParsing)
         .onSuccess { text in
            slf?.works.updateAmount
               .doAsync((text, true))

            slf?.works.isCorrect
               .doAsync()
               .onSuccess(slf?.setState) { .coinInputSuccess(text, $0) }
               .onFail(slf?.setState) { .coinInputSuccess(text, $0) }
         }
         .onFail { (text: String) in
            slf?.works.updateAmount
               .doAsync((text, false))
               .onSuccess(slf?.setState) { .coinInputSuccess(text, false) }
         }

      events.reasonInputChanged
         .doNext(work: works.reasonInputParsing)
         .onSuccess { text in
            slf?.works.updateReason
               .doAsync((text, true))

            slf?.works.isCorrect
               .doAsync()
               .onSuccess(slf?.setState) { .reasonInputSuccess(text, $0) }
               .onFail(slf?.setState) { .reasonInputSuccess(text, $0) }
         }
         .onFail { (text: String) in
            slf?.works.updateReason
               .doAsync((text, false))
               .onSuccess(slf?.setState, .reasonInputSuccess(text, false))
         }
   }
}
