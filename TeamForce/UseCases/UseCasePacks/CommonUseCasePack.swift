//
//  CommonUseCasePack.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct ApiUseCase: ApiUseCaseRegistry, WorkBasket {

   let retainer: Retainer = .init()

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

   let safeStringStorage: StringStorageWorker
   let userProfileApiModel: ProfileApiWorker

   let loginApiModel: AuthApiWorker
   let logoutApiModel: LogoutApiWorker
   let balanceApiModel: GetBalanceApiWorker

   let searchUserApiWorker: SearchUserApiWorker
   let sendCoinApiWorker: SendCoinApiWorker
   let getTransactionsApiWorker: GetTransactionsApiWorker
   let getTransactionByIdApiWorker: GetTransactionByIdApiWorker
   let getUsersListApiWorker: GetUsersListApiWorker
   let getFeedsApiWorker: GetFeedsApiWorker
   let getPeriodsApiWorker: GetPeriodsApiWorker
   let getStatByPeriodIdApiWorker: GetStatByPeriodIdApiWorker
}
