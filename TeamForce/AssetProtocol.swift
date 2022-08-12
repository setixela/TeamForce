//
//  AssetProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

import ReactiveWorks

protocol ServiceProtocol: InitProtocol {
   var apiEngine: ApiEngineProtocol { get }
   var safeStringStorage: StringStorageProtocol { get }
}

protocol AssetProtocol: AssetRoot
   where
   Scene: ScenesProtocol,
   Service: ServiceProtocol,
   Design: DesignProtocol,
   Text: TextsProtocol
{
   static var router: MainRouter<Scene>? { get set }

   static var apiUseCase: ApiUseCase { get }

   typealias Asset = Self
}

extension AssetProtocol {
   static var apiUseCase: ApiUseCase {
      .init(
         safeStringStorage: StringStorageWorker(engine: service.safeStringStorage),
         userProfileApiModel: ProfileApiWorker(apiEngine: service.apiEngine),
         loginApiModel: AuthApiWorker(apiEngine: service.apiEngine),
         logoutApiModel: LogoutApiWorker(apiEngine: service.apiEngine),
         balanceApiModel: GetBalanceApiWorker(apiEngine: service.apiEngine),
         searchUserApiWorker: SearchUserApiWorker(apiEngine: service.apiEngine),
         sendCoinApiWorker: SendCoinApiWorker(apiEngine: service.apiEngine),
         getTransactionsApiWorker: GetTransactionsApiWorker(apiEngine: service.apiEngine),
         getTransactionByIdApiWorker: GetTransactionByIdApiWorker(apiEngine: service.apiEngine),
         getUsersListApiWorker: GetUsersListApiWorker(apiEngine: service.apiEngine)
      )
   }
}

protocol ScenesProtocol: InitProtocol {
   var digitalThanks: SceneModelProtocol { get }
   var login: SceneModelProtocol { get }
   var verifyCode: SceneModelProtocol { get }
   var loginSuccess: SceneModelProtocol { get }
   var register: SceneModelProtocol { get }
   var main: SceneModelProtocol { get }
   var profile: SceneModelProtocol { get }

   // plays
   var playground: SceneModelProtocol { get }
}
