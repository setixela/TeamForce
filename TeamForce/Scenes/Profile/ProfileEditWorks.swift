//
//  ProfileEditWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks

protocol ProfileEditWorksProtocol: Assetable {
   var updateContact: Work<(Int, String), Void> { get }
}

final class ProfileEditWorks<Asset: AssetProtocol>: BaseSceneWorks<ProfileEditWorks.Temp, Asset>, ProfileEditWorksProtocol {
   //
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var loginName: String?
      var smsCodeInput: String?
      var authResult: AuthResult?
   }

   // MARK: - Works

   var updateContact: Work<(Int, String), Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         
         self?.useCase.updateContact
            .doAsync(input)
            .onSuccess {
               print("I am success")
               work.success(result: $0)
            }
            .onFail {
               print("I am fail")
               work.fail(())
            }
      }
      .retainBy(retainer)
   }
}
