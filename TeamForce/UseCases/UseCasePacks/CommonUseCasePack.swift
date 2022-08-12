//
//  CommonUseCasePack.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

struct ApiUseCase { // }: ApiUseCaseRegistry {
   // MARK: - UseCases

   lazy var loadProfile: LoadProfileUseCase = .init(safeStringStorage: safeStringStorage, userProfileApiModel: userProfileApiModel)
   lazy var loadBalance: LoadBalanceUseCase = .init(safeStringStorage: safeStringStorage, balanceApiModel: balanceApiModel)
   lazy var login: LoginUseCase = .init(authApiWorker: loginApiModel)
   lazy var logout: LogoutUseCase = .init(safeStringStorage: safeStringStorage, logoutApiModel: logoutApiModel)
   lazy var userSearch: UserSearchUseCase = .init(searchUserApiModel: searchUserApiWorker)
   lazy var getTransactions: GetTransactionsUseCase = .init(safeStringStorage: safeStringStorage, getTransactionsApiWorker: getTransactionsApiWorker)
   lazy var sendCoin: SendCoinUseCase = .init(sendCoinApiModel: sendCoinApiWorker)

   // MARK: - Dependencies

   let safeStringStorage: StringStorageWorker
   let userProfileApiModel: ProfileApiWorker

   let loginApiModel: AuthApiWorker
   let logoutApiModel: LogoutApiWorker
   let balanceApiModel: GetBalanceApiWorker

   let searchUserApiWorker: SearchUserApiWorker
   let sendCoinApiWorker: SendCoinApiWorker
   let getTransactionsApiWorker: GetTransactionsApiWorker
}
