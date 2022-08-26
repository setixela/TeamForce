//
//  CommonUseCasePack.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

protocol Retainable {
   var retainer: Retainer { get }
}

// Не забываем Ретайнить ворки

final class ApiUseCase<Asset: AssetProtocol>: InitProtocol, Assetable, WorkBasket, Retainable {
   //

   init() {}

   let retainer = Retainer()

   private var storageUseCase = Asset.storageUseCase

   var safeStringStorage: StringStorageWorker {
      StringStorageWorker(engine: Asset.service.safeStringStorage)
   }

   // MARK: - UseCases

   // Login / Logout
   var login: LoginUseCase.WRK {
      LoginUseCase(
         authApiWorker: loginApiModel
      )
      .retainedWork(retainer)
   }

   var verifyCode: VerifyCodeUseCase.WRK {
      VerifyCodeUseCase(
         verifyCodeApiWorker: verifyCodeApiWorker
      )
      .retainedWork(retainer)
   }

   var logout: LogoutUseCase.WRK {
      LogoutUseCase(
         loadToken: storageUseCase.loadToken,
         logoutApiModel: logoutApiModel
      )
      .retainedWork(retainer)
   }

   // Profile

   var loadProfile: LoadProfileUseCase.WRK {
      LoadProfileUseCase(
         loadToken: storageUseCase.loadToken,
         userProfileApiModel: userProfileApiModel
      )
      .retainedWork(retainer)
   }

   var loadBalance: LoadBalanceUseCase.WRK {
      LoadBalanceUseCase(
         loadToken: storageUseCase.loadToken,
         balanceApiModel: balanceApiModel
      )
      .retainedWork(retainer)
   }

   var userSearch: UserSearchUseCase.WRK {
      UserSearchUseCase(searchUserApiModel: searchUserApiWorker)
         .retainedWork(retainer)
   }

   var getTransactions: GetTransactionsUseCase.WRK {
      GetTransactionsUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionsApiWorker: getTransactionsApiWorker
      )
      .retainedWork(retainer)
   }

   var sendCoin: SendCoinUseCase.WRK {
      SendCoinUseCase(
         sendCoinApiModel: sendCoinApiWorker
      )
      .retainedWork(retainer)
   }

   var getTransactionById: GetTransactionByIdUseCase.WRK {
      GetTransactionByIdUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionByIdApiModel: getTransactionByIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getTransactionsByPeriod: GetTransactionsByPeriodUseCase.WRK {
      GetTransactionsByPeriodUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionsByPeriodApiModel: getTransactionsByPeriodApiWorker
      )
      .retainedWork(retainer)
   }

   var cancelTransactionById: CancelTransactionByIdUseCase.WRK {
      CancelTransactionByIdUseCase(
         safeStringStorage: safeStringStorage,
         cancelTransactionByIdApiWorker: cancelTransactionByIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getUsersList: GetUsersListUseCase.WRK {
      GetUsersListUseCase(
         safeStringStorage: safeStringStorage,
         getUsersListApiWorker: getUsersListApiWorker
      )
      .retainedWork(retainer)
   }

   var getFeed: GetFeedUseCase.WRK {
      GetFeedUseCase(
         safeStringStorage: safeStringStorage,
         getFeedsApiWorker: getFeedsApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriods: GetPeriodsUseCase.WRK {
      GetPeriodsUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodsApiWorker: getPeriodsApiWorker
      )
      .retainedWork(retainer)
   }

   var getStatByPeriodId: GetStatByPeriodIdUseCase.WRK {
      GetStatByPeriodIdUseCase(
         safeStringStorage: safeStringStorage,
         getStatByPeriodIdApiWorker: getStatByPeriodIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getCurrentPeriod: GetCurrentPeriodUseCase.WRK {
      GetCurrentPeriodUseCase(
         safeStringStorage: safeStringStorage,
         getCurrentPeriodApiWorker: getCurrentPeriodApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriodByDate: GetPeriodByDateUseCase.WRK {
      GetPeriodByDateUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodByDateApiWorker: getPeriodByDateApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriodsFromDate: GetPeriodsFromDateUseCase.WRK {
      GetPeriodsFromDateUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodsFromDateApiWorker: getPeriodsFromDateApiWorker
      )
      .retainedWork(retainer)
   }

   var updateProfileImage: UpdateProfileImageUseCase.WRK {
      UpdateProfileImageUseCase(
         safeStringStorage: safeStringStorage,
         updateProfileImageApiWorker: updateProfileImageApiWorker
      )
      .retainedWork(retainer)
   }

   // MARK: - Dependencies

   private var userProfileApiModel: ProfileApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var loginApiModel: AuthApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var verifyCodeApiWorker: VerifyApiModel { .init(apiEngine: Asset.service.apiEngine) }
   private var logoutApiModel: LogoutApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var balanceApiModel: GetBalanceApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var searchUserApiWorker: SearchUserApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var sendCoinApiWorker: SendCoinApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionsApiWorker: GetTransactionsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionByIdApiWorker: GetTransactionByIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getUsersListApiWorker: GetUsersListApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getFeedsApiWorker: GetFeedsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodsApiWorker: GetPeriodsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getStatByPeriodIdApiWorker: GetStatByPeriodIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionsByPeriodApiWorker: GetTransactionsByPeriodApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var cancelTransactionByIdApiWorker: CancelTransactionByIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getCurrentPeriodApiWorker: GetCurrentPeriodApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodByDateApiWorker: GetPeriodByDateApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodsFromDateApiWorker: GetPeriodsFromDateApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var updateProfileImageApiWorker: UpdateProfileImageApiWorker { .init(apiEngine: Asset.service.apiEngine) }
}
