//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import Foundation
import ReactiveWorks

struct TransactScenarioEvents {
   let userSearchTFBeginEditing: VoidWork<String>
   let userSearchTFDidEditingChanged: VoidWork<String>
   let userSelected: VoidWork<IndexPath>
   let sendButtonEvent: VoidWork<Void>

   let transactInputChanged: VoidWork<String>
   let reasonInputChanged: VoidWork<String>
}

enum TransactState {
   case loadProfilError
   case loadTransactionsError

   case loadTokensSuccess
   case loadTokensError

   case loadBalanceSuccess(Int)
   case loadBalanceError

   case loadUsersListSuccess([FoundUser])
   case loadUsersListError

   case searchTextFieldBeginEditing([FoundUser])
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
         .onSuccess {
            slf?.setState(.loadTokensSuccess)
         }
         .onFail {
            slf?.setState(.loadTokensError)
         }
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess {
            slf?.setState(.loadBalanceSuccess($0.distr.amount))
         }
         .onFail {
            slf?.setState(.loadBalanceError)
         }
         // then break data
         .doInput(())
         // then load 10 user list
         .doNext(work: works.getUserList)
         .onSuccess {
            slf?.setState(.loadUsersListSuccess($0))
         }
         .onFail {
            slf?.setState(.loadUsersListError)
         }

      // load tokens, then load balance, then load 10 user list
      events.userSearchTFBeginEditing
         .doNext(usecase: IsEmpty())
         .onSuccess {
            slf?.works.getUserList
               .doAsync()
               .onSuccess {
                  slf?.setState(.searchTextFieldBeginEditing($0))
               }
         }

      // on input event, then check input is not empty, then search user
      events.userSearchTFDidEditingChanged
         .onSuccess {
            slf?.setState(.userSearchTFDidEditingChangedSuccess)
         }
         .doNext(usecase: IsEmpty())
         .onSuccess {
            slf?.works.getUserList
               .doAsync()
               .onSuccess {
                  slf?.setState(.emptyUserSearchTF($0))
               }
         }
         .doNext(work: works.searchUser)
         .onSuccess {
            slf?.setState(.listOfFoundUsers($0))
         }
         .onFail {
            print("Search user API Error")
         }

      events.userSelected
         .doNext(work: works.mapIndexToUser)
         .onSuccess {
            slf?.setState(.userSelectedSuccess($0))
         }

      events.sendButtonEvent
         .doNext(work: works.sendCoins)
         .onSuccess { tuple in
            slf?.works.reset
               .doAsync()
            slf?.setState(.sendCoinSuccess(tuple))
         }
         .onFail {
            slf?.setState(.sendCoinError)
         }

      events.transactInputChanged
         .doNext(work: works.coinInputParsing)
         .onSuccess { text in
            slf?.works.updateAmount
               .doAsync((text, true))
            
            slf?.works.isCorrect
               .doAsync()
               .onSuccess {
                  slf?.setState(.coinInputSuccess(text, $0))
               }
               .onFail {
                  slf?.setState(.coinInputSuccess(text, $0))
               }
         }
         .onFail { (text: String) in
            slf?.works.updateAmount
               .doAsync((text, false))
               .onSuccess {
                  slf?.setState(.coinInputSuccess(text, false))
               }
         }

      events.reasonInputChanged
         .doNext(work: works.reasonInputParsing)
         .onSuccess { text in
            slf?.works.updateReason
               .doAsync((text, true))
            
            slf?.works.isCorrect
               .doAsync()
               .onSuccess {
                  slf?.setState(.reasonInputSuccess(text, $0))
               }
               .onFail {
                  slf?.setState(.reasonInputSuccess(text, $0))
               }
         }
         .onFail { (text: String) in
            slf?.works.updateReason
               .doAsync((text, false))
               .onSuccess {
                  slf?.setState(.reasonInputSuccess(text, false))
               }
         }
   }
}
