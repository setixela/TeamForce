//
//  ProfileEditWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

protocol ProfileEditWorksProtocol: Assetable {
   var loadProfile: WorkVoid<UserData> { get }
   var updateProfile: Work<UpdateProfileRequest, Void> { get }
   var createFewContacts: Work<CreateFewContactsRequest, Void> { get }
   var sendRequests: WorkVoid<Void> { get }
   var addImage: Work<UIImage, UIImage> { get }
   var updateAvatar: Work<UpdateImageRequest, Void> { get }
}

final class ProfileEditWorks<Asset: AssetProtocol>: BaseSceneWorks<ProfileEditWorks.Temp, Asset>, ProfileEditWorksProtocol {
   //
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var contacts: Contacts = .init()
      var profileId: Int?
      var emailId: Int?
      var phoneId: Int?
      var image: UIImage?
      var croppedImage: UIImage?
   }

   // MARK: - Works

   var loadProfile: WorkVoid<UserData> { .init { [weak self] work in
      self?.useCase.loadProfile
         .doAsync()
         .onSuccess {
            Self.store.profileId = $0.profile.id
            Self.store.emailId = nil
            Self.store.phoneId = nil
            if let contacts = $0.profile.contacts {
               for contact in contacts {
                  switch contact.contactType {
                  case "@":
                     Self.store.emailId = contact.id
                  case "P":
                     Self.store.phoneId = contact.id
                  default:
                     print("Contact error")
                  }
               }
            }
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }

   }.retainBy(retainer) }

   var updateProfile: Work<UpdateProfileRequest, Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         self?.useCase.updateProfile
            .doAsync(input)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }.retainBy(retainer)
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
               work.fail()
            }
      }.retainBy(retainer)
   }

   var updateAvatar: Work<UpdateImageRequest, Void> {
      .init { [weak self] work in
         guard let input = work.input else { return }
         self?.useCase.updateProfileImage
            .doAsync(input)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }.retainBy(retainer)
   }

   var updateStorage: Work<Contacts, Void> {
      .init { work in
         guard let input = work.input else { return }

         Self.store.contacts = input
         work.success()
      }.retainBy(retainer)
   }

   lazy var sendRequests = WorkVoid<Void> { work in
      let updateProfileRequest = self.formUpdateProfileRequest()
      let fewContactsRequest = self.formFewContactsRequest()
      let avatarRequest = self.formAvatarRequest()

      self.updateProfile
         .doAsync(updateProfileRequest)
         .onSuccess {
            if fewContactsRequest == nil && avatarRequest == nil {
               work.success()
            }
         }
         .onFail {
            work.fail()
         }
         .doMap { fewContactsRequest }
         .doNext(self.createFewContacts)
         .onSuccess {
            if avatarRequest == nil {
               work.success()
            }
            
         }
         .onFail {
            work.fail()
         }
         .doMap { avatarRequest }
         .doNext(self.updateAvatar)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }
}

// MARK: - Add avatar

extension ProfileEditWorks {
   var addImage: Work<UIImage, UIImage> { .init { work in
      Self.store.image = work.unsafeInput
      work.success(result: work.unsafeInput)
   } }
   
   var saveCroppedImage: Work<UIImage, UIImage> { .init { work in
      Self.store.croppedImage = work.unsafeInput
      work.success(result: work.unsafeInput)
   }}
}

// MARK: - Form Requests

private extension ProfileEditWorks {
   func formUpdateProfileRequest() -> UpdateProfileRequest? {
      guard
         let profileId = Self.store.profileId
      else { return nil }

      var info: [String: String] = [:]

      if let firstName = Self.store.contacts.name {
         info["first_name"] = firstName
      }
      if let surname = Self.store.contacts.surname {
         info["surname"] = surname
      }
      if let middleName = Self.store.contacts.middlename {
         info["middle_name"] = middleName
      }
      
      if let telegram = Self.store.contacts.telegram {
         info["tg_name"] = telegram
      }

      let updateProfileRequest = UpdateProfileRequest(token: "",
                                                      id: profileId,
                                                      info: info)
      return updateProfileRequest
   }

   func formFewContactsRequest() -> CreateFewContactsRequest? {
      var info: [FewContacts] = []

      if let email = Self.store.contacts.email {
         var emailDic = FewContacts(id: nil,
                                    contactType: "@",
                                    contactId: email)
         if let emailId = Self.store.emailId {
            emailDic = FewContacts(id: emailId,
                                   contactType: "@",
                                   contactId: email)
         }
         info.append(emailDic)
      }

      if let phone = Self.store.contacts.phone {
         var phoneDic = FewContacts(id: nil,
                                    contactType: "P",
                                    contactId: phone)
         if let phoneId = Self.store.phoneId {
            phoneDic = FewContacts(id: phoneId,
                                   contactType: "P",
                                   contactId: phone)
         }
         info.append(phoneDic)
      }

      let createFewContactsRequest = CreateFewContactsRequest(token: "",
                                                              info: info)
      return createFewContactsRequest
   }

   func formAvatarRequest() -> UpdateImageRequest? {
      guard
         let profileId = Self.store.profileId,
         let avatar = Self.store.image
      else { return nil }
      let request = UpdateImageRequest(token: "",
                                       id: profileId,
                                       photo: avatar,
                                       croppedPhoto: Self.store.croppedImage)
      return request
   }
}
