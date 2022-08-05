//
//  UseCaseRegistry.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

protocol ApiUseCaseRegistry {
   //
   var loadProfile: LoadProfileUseCase { get }
   var loadBalance: LoadBalanceUseCase { get }
   //
   var login: LoginUseCase { get }
   var logout: LogoutUseCase { get }
   //
   var userSearch: UserSearchUseCase { get }
   //
   var sendCoin: SendCoinUseCase { get }
   
}

struct UserSearchUseCase: UseCaseProtocol {

   let searchUserApiModel: SearchUserApiWorker

   func work() -> Work<SearchUserRequest, [FoundUser]> {
      searchUserApiModel.work
   }
}




