//
//  ProfileEditWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks

protocol ProfileEditWorksProtocol: Assetable {
   var updateContact: Work<(Int, String), Void> { get }
   var createContact: Work<CreateContactRequest, Void> { get }
   var updateProfile: Work<UpdateProfileRequest, Void> { get }
   var createFewContacts: Work<CreateFewContactsRequest, Void> { get }
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
         print("input for update contact \(input)")
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
   
   var createContact: Work<CreateContactRequest, Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         self?.useCase.createContact
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
   
   var updateProfile: Work<UpdateProfileRequest, Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         self?.useCase.updateProfile
            .doAsync(input)
            .onSuccess {
               print("I am success")
               work.success(result: $0)
            }
            .onFail {
               print("I am fail to update profile")
               work.fail(())
            }
      }
      .retainBy(retainer)
   }
   
   var createFewContacts: Work<CreateFewContactsRequest, Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         self?.useCase.createFewContacts
            .doAsync(input)
            .onSuccess {
               print("created few contacts")
               work.success(result: $0)
            }
            .onFail {
               print("failed to create few contacts")
               work.fail(())
            }
      }
      .retainBy(retainer)
   }
   

}
