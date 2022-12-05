//
//  MainWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

final class MainWorksStorage: InitProtocol {
   var currentUser: UserData?
}

protocol MainWorksProtocol {
   var loadProfile: WorkVoid<UserData> { get }
}

final class MainWorks<Asset: AssetProtocol>: BaseWorks<MainWorksStorage, Asset>, MainWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadProfile: WorkVoid<UserData> { apiUseCase.loadProfile }
   
   var getNotificationsAmount: Work<Void, Int> { .init { [weak self] work in
      self?.apiUseCase.getNotificationsAmount
         .doAsync()
         .onSuccess {
            work.success($0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
