//
//  TransactSceneWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import Foundation
import ReactiveWorks

protocol TransactWorksProtocol: SceneWorks {
   // api works
   var loadBalance: Work<Void, Balance> { get }
   var searchUser: Work<String, [FoundUser]> { get }
   var sendCoins: Work<(amount: String, reason: String),
      (recipient: String, info: SendCoinRequest)> { get }
   var getUserList: Work<Void, [FoundUser]> { get }
   // data works
   var loadTokens: Work<Void, Void> { get }
   // index mapper
   var mapIndexToUser: Work<IndexPath, FoundUser> { get }
   // parsing input
   var coinInputParsing: Work<String, String> { get }
   var reasonInputParsing: Work<String, String> { get }
}

// Transact Works - (если нужно хранилище временное, то наследуемся от BaseSceneWorks)
final class TransactWorks<Asset: AssetProtocol>: BaseSceneWorks<TransactWorks.Temp, Asset>, TransactWorksProtocol {
   // api works
   private lazy var apiUseCase = Asset.apiUseCase
   // parsing input
   private lazy var coinInputParser = CoinInputCheckerModel()
   private lazy var reasonInputParser = ReasonCheckerModel()

   private lazy var retainer = Retainer()

   // storage
   class Temp: InitProtocol {
      required init() {}
      
      var tokens: (token: String, csrf: String) = ("", "")
      var foundUsers: [FoundUser] = []
      var recipientID = 0
      var recipientUsername = ""

      var inputAmountText = ""
      var inputReasonText = ""
   }

   // MARK: - Works

   lazy var coinInputParsing = coinInputParser.work
   lazy var reasonInputParsing = reasonInputParser.work

   lazy var loadBalance = apiUseCase.loadBalance.work

   lazy var loadTokens = Work<Void, Void> { [weak self] work in
      self?.apiUseCase.safeStringStorage
         .doAsync("token")
         .onSuccess {
            Self.store.tokens.token = $0
         }.onFail {
            work.fail(())
         }.doInput("csrftoken")
         .doNext(worker: self?.apiUseCase.safeStringStorage)
         .onSuccess {
            Self.store.tokens.csrf = $0
            work.success(result: ())
         }.onFail {
            work.fail(())
         }
   }

   lazy var searchUser = Work<String, [FoundUser]> { [weak self] work in

      let request = SearchUserRequest(
         data: work.unsafeInput,
         token: Self.store.tokens.token,
         csrfToken: Self.store.tokens.csrf
      )

      self?.apiUseCase.userSearch.work
         .retainBy(self?.retainer)
         .doAsync(request)
         .onSuccess { result in
            Self.store.foundUsers = result
            work.success(result: result)
         }.onFail {
            work.fail(())
         }
   }

   lazy var sendCoins = Work<(amount: String, reason: String),
      (recipient: String, info: SendCoinRequest)> { work in

      let request = SendCoinRequest(
         token: Self.store.tokens.token,
         csrfToken: Self.store.tokens.csrf,
         recipient: Self.store.recipientID,
         amount: work.unsafeInput.amount,
         reason: work.unsafeInput.reason
      )

      self.apiUseCase.sendCoin.work
         .retainBy(self.retainer)
         .doAsync(request)
         .onSuccess {
            let tuple = (Self.store.recipientUsername, request)
            work.success(result: tuple)
         }.onFail { (_: String) in
            work.fail(())
         }
   }

   lazy var getUserList = Work<Void, [FoundUser]> { [weak self] work in
      self?.apiUseCase.getUsersList.work
         .retainBy(self?.retainer)
         .doAsync()
         .onSuccess { result in
            Self.store.foundUsers = result
            work.success(result: result)
         }.onFail {
            work.fail(())
         }
   }

   lazy var mapIndexToUser = Work<IndexPath, FoundUser> { work in

      // TODO: - 2d sections mapping to 1d array error
      let user = Self.store.foundUsers[work.unsafeInput.row]

      Self.store.recipientUsername = user.name
      Self.store.recipientID = user.userId
      work.success(result: user)
   }
}
