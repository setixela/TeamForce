//
//  UseCaseRegistry.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

protocol ApiUseCaseRegistry {
   //
   var loadProfile: LoadProfileUseCase { get }
   var loadBalance: LoadBalanceUseCase { get }
   //
   var login: LoginUseCase { get }
   var logout: LogoutUseCase { get }
   //
   var userSearch: UserSearchUseCase { get }
}

struct UserSearchUseCase: UseCaseProtocol {

   let searchUserApiModel: SearchUserApiWorker

   func work() -> Work<SearchUserRequest, [FoundUser]> {
      searchUserApiModel.work
   }
}

