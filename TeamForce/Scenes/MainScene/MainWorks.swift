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
   var loadProfile: VoidWork<UserData> { get }
}

final class MainWorks<Asset: AssetProtocol>: BaseSceneWorks<MainWorksStorage, Asset>, MainWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadProfile: VoidWork<UserData> { apiUseCase.loadProfile }
}
