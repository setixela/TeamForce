//
//  TransactSceneWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import ReactiveWorks

protocol TransactSceneWorksProtocol: SceneWorks {
   // api works
   var loadBalance: Work<Void, Balance> { get }
   var searchUser: Work<String, [FoundUser]> { get }
   var sendCoins: Work<(amount: String, reason: String), (recipient: String, info: SendCoinRequest)> { get }

   // data works
   var loadTokens: Work<Void, Void> { get }
   var mapIndexToUser: Work<Int, FoundUser> { get }

   // parsing input
   var coinInputParsing: Work<String, String> { get }
   var reasonInputParsing: Work<String, String> { get }
}

final class TransactSceneWorks<Asset: AssetProtocol>: TransactSceneWorksProtocol {
   private lazy var searchUserWorker = SearchUserApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)
   private lazy var sendCoinApiWorker = SendCoinApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var loadBalanceUseCase = Asset.apiUseCase.loadBalance

   private lazy var coinInputParser = CoinInputCheckerModel()
   private lazy var reasonInputParser = ReasonCheckerModel()

   // storage
   struct TempStorage {
      var tokens: (token: String, csrf: String) = ("", "")
      var foundUsers: [FoundUser] = []
      var recipientID = 0
      var recipientUsername = ""
   }

   var tempStorage: TempStorage = .init()

   // MARK: - Works

   lazy var coinInputParsing = coinInputParser.work
   lazy var reasonInputParsing = reasonInputParser.work

   lazy var loadBalance = loadBalanceUseCase.work()

   lazy var loadTokens = Work<Void, Void> { [weak self] work in
      self?.safeStringStorage
         .doAsync("token")
         .onSuccess {
            self?.tempStorage.tokens.token = $0
         }.onFail {
            work.fail(())
         }.doInput("csrftoken")
         .doNext(worker: self?.safeStringStorage)
         .onSuccess {
            self?.tempStorage.tokens.csrf = $0
            work.success(result: ())
         }.onFail {
            work.fail(())
         }
   }

   lazy var searchUser = Work<String, [FoundUser]> { [weak self] work in
      guard let self = self else {
         return
      }

      let request = SearchUserRequest(
         data: work.unsafeInput,
         token: self.tempStorage.tokens.token,
         csrfToken: self.tempStorage.tokens.csrf
      )

      self.searchUserWorker
         .doAsync(request)
         .onSuccess { result in
            self.tempStorage.foundUsers = result
            work.success(result: result)
         }.onFail {
            work.fail(())
         }
   }

   lazy var sendCoins = Work<(amount: String, reason: String),
      (recipient: String, info: SendCoinRequest)> { [weak self] work in
      guard let self = self else {
         return
      }

      let request = SendCoinRequest(
         token: self.tempStorage.tokens.token,
         csrfToken: self.tempStorage.tokens.csrf,
         recipient: self.tempStorage.recipientID,
         amount: work.unsafeInput.amount,
         reason: work.unsafeInput.reason
      )

      self.sendCoinApiWorker
         .doAsync(request)
         .onSuccess {
            let tuple = (self.tempStorage.recipientUsername, request)
            work.success(result: tuple)
         }.onFail { (_: String) in
            work.fail(())
         }
   }

   lazy var mapIndexToUser = Work<Int, FoundUser> { [weak self] work in
      guard let self = self else {
         return
      }

      let user = self.tempStorage.foundUsers[work.unsafeInput]
      self.tempStorage.recipientUsername = user.name
      self.tempStorage.recipientID = user.userId
      work.success(result: user)
   }
}
