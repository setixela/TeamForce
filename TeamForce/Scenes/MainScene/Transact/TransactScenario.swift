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
      let setState = setState

      works.loadTokens
         .doAsync()
         .onSuccess {
            setState(.loadTokensSuccess)
         }
         .onFail {
            setState(.loadTokensError)
         }
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess {
            setState(.loadBalanceSuccess($0.distr.amount))
         }
         .onFail {
            setState(.loadBalanceError)
         }
         // then break data
         .doInput(())
         // then load 10 user list
         .doNext(work: works.getUserList)
         .onSuccess {
            setState(.loadUsersListSuccess($0))
         }
         .onFail {
            setState(.loadUsersListError)
         }

      events.userSearchTFBeginEditing
         .doNext(usecase: IsEmpty())
         .onSuccess {
            slf?.works.getUserList
               .doAsync()
               .onSuccess {
                  setState(.searchTextFieldBeginEditing($0))
               }
         }

      // on input event, then check input is not empty, then search user
      events.userSearchTFDidEditingChanged
         .onSuccess {
            setState(.userSearchTFDidEditingChangedSuccess)
         }
         .doNext(usecase: IsEmpty())
         .onSuccess {
            slf?.works.getUserList
               .doAsync()
               .onSuccess {
                  setState(.emptyUserSearchTF($0))
               }
         }
         .doNext(work: works.searchUser)
         .onSuccess {
            setState(.listOfFoundUsers($0))
         }
         .onFail {
            print("Search user API Error")
         }

      events.userSelected
         .doNext(work: works.mapIndexToUser)
         .onSuccess {
            setState(.userSelectedSuccess($0))
         }

      events.sendButtonEvent
         .doNext(work: works.sendCoins)
         .onSuccess { tuple in
            setState(.sendCoinSuccess(tuple))
         }
         .onFail {
            setState(.sendCoinError)
         }
         .doInput(())
         .doNext(work: works.reset)

      events.transactInputChanged
         .doNext(work: works.coinInputParsing)
         .onSuccess { text in
            slf?.works.updateAmount
               .doAsync((text, true))
            
            slf?.works.isCorrect
               .doAsync()
               .onSuccess {
                  setState(.coinInputSuccess(text, $0))
               }
               .onFail {
                  setState(.coinInputSuccess(text, $0))
               }
         }
         .onFail { (text: String) in
            slf?.works.updateAmount
               .doAsync((text, false))
               .onSuccess {
                  setState(.coinInputSuccess(text, false))
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
                  setState(.reasonInputSuccess(text, $0))
               }
               .onFail {
                  setState(.reasonInputSuccess(text, $0))
               }
         }
         .onFail { (text: String) in
            slf?.works.updateReason
               .doAsync((text, false))
               .onSuccess {
                  setState(.reasonInputSuccess(text, false))
               }
         }
   }
}
