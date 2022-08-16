//
//  CommonUseCasePack.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct ApiUseCase<Asset: AssetProtocol>: Assetable, WorkBasket {
   //
   let retainer = Retainer()

   var safeStringStorage: StringStorageWorker {
      StringStorageWorker(engine: Asset.service.safeStringStorage)
   }

   // MARK: - UseCases

   var loadProfile: LoadProfileUseCase {
      .init(safeStringStorage: safeStringStorage, userProfileApiModel: userProfileApiModel)
   }

   var loadBalance: LoadBalanceUseCase {
      .init(safeStringStorage: safeStringStorage, balanceApiModel: balanceApiModel)
   }

   var login: LoginUseCase {
      .init(authApiWorker: loginApiModel)
   }

   var verifyCode: VerifyCodeUseCase {
      .init(verifyCodeApiWorker: verifyCodeApiWorker)
   }

   var logout: LogoutUseCase {
      .init(safeStringStorage: safeStringStorage, logoutApiModel: logoutApiModel)
   }

   var userSearch: UserSearchUseCase {
      .init(searchUserApiModel: searchUserApiWorker)
   }

   var getTransactions: GetTransactionsUseCase {
      .init(safeStringStorage: safeStringStorage, getTransactionsApiWorker: getTransactionsApiWorker)
   }

   var sendCoin: SendCoinUseCase {
      .init(sendCoinApiModel: sendCoinApiWorker)
   }

   var getTransactionById: GetTransactionByIdUseCase {
      .init(safeStringStorage: safeStringStorage, getTransactionByIdApiModel: getTransactionByIdApiWorker)
   }

   var getUsersList: GetUsersListUseCase {
      .init(safeStringStorage: safeStringStorage, getUsersListApiWorker: getUsersListApiWorker)
   }

   var getFeed: GetFeedUseCase {
      .init(safeStringStorage: safeStringStorage, getFeedsApiWorker: getFeedsApiWorker)
   }

   var getPeriods: GetPeriodsUseCase {
      .init(safeStringStorage: safeStringStorage, getPeriodsApiWorker: getPeriodsApiWorker)
   }

   var getStatByPeriodId: GetStatByPeriodIdUseCase {
      .init(safeStringStorage: safeStringStorage, getStatByPeriodIdApiWorker: getStatByPeriodIdApiWorker)
   }

   // MARK: - Dependencies

   private var userProfileApiModel: ProfileApiWorker { ProfileApiWorker(apiEngine: Asset.service.apiEngine) }
   private var loginApiModel: AuthApiWorker { AuthApiWorker(apiEngine: Asset.service.apiEngine) }
   private var verifyCodeApiWorker: VerifyApiModel { VerifyApiModel(apiEngine: Asset.service.apiEngine) }
   private var logoutApiModel: LogoutApiWorker { LogoutApiWorker(apiEngine: Asset.service.apiEngine) }
   private var balanceApiModel: GetBalanceApiWorker { GetBalanceApiWorker(apiEngine: Asset.service.apiEngine) }
   private var searchUserApiWorker: SearchUserApiWorker { SearchUserApiWorker(apiEngine: Asset.service.apiEngine) }
   private var sendCoinApiWorker: SendCoinApiWorker { SendCoinApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getTransactionsApiWorker: GetTransactionsApiWorker { GetTransactionsApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getTransactionByIdApiWorker: GetTransactionByIdApiWorker { GetTransactionByIdApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getUsersListApiWorker: GetUsersListApiWorker { GetUsersListApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getFeedsApiWorker: GetFeedsApiWorker { GetFeedsApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getPeriodsApiWorker: GetPeriodsApiWorker { GetPeriodsApiWorker(apiEngine: Asset.service.apiEngine) }
   private var getStatByPeriodIdApiWorker: GetStatByPeriodIdApiWorker { GetStatByPeriodIdApiWorker(apiEngine: Asset.service.apiEngine) }
}

