//
//  ProfileEditWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks

protocol ProfileEditWorksProtocol: Assetable {
   var loadProfile: VoidWork<UserData> { get }
   var updateProfile: Work<UpdateProfileRequest, Void> { get }
   var createFewContacts: Work<CreateFewContactsRequest, Void> { get }
   var sendRequests: VoidWork<Void> { get }
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
   }

   // MARK: - Works

   var loadProfile: VoidWork<UserData> { .init { [weak self] work in
      self?.useCase.loadProfile
         .doAsync()
         .onSuccess {
            Self.store.profileId = $0.profile.id

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
            work.fail(())
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
               work.fail(())
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
               work.fail(())
            }
      }.retainBy(retainer)
   }

   var updateStorage: Work<Contacts, Void> {
      .init { work in
         guard let input = work.input else { return }

         Self.store.contacts = input
         work.success(result: ())
      }.retainBy(retainer)
   }

   lazy var sendRequests = VoidWork<Void> { work in
      let updateProfileRequest = self.formUpdateProfileRequest()

      self.updateProfile
         .doAsync(updateProfileRequest)
         .onSuccess {
            print("updated profile")
         }
         .onFail {
            print("failed to update profile")
         }

      let fewContactsRequest = self.formFewContactsRequest()
      
      self.createFewContacts
         .doAsync(fewContactsRequest)
         .onSuccess {
            print("Created few contacts")
         }
         .onFail {
            print("few contacts not created")
         }
      work.success(result: ())
   }
}

extension ProfileEditWorks {
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

      let updateProfileRequest = UpdateProfileRequest(token: "",
                                                      id: profileId,
                                                      info: info)
      return updateProfileRequest
   }

   func formFewContactsRequest() -> CreateFewContactsRequest? {
      
      var info: [FewContacts] = []
      
      if let email = Self.store.contacts.email {
         var emailDic: FewContacts = FewContacts(id: nil,
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
         var phoneDic: FewContacts = FewContacts(id: nil,
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
}
