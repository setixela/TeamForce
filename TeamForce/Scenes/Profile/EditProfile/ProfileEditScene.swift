//
//  ProfileEditScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

enum ProfileEditState {
   case initial
   case error
   case userDataDidLoad(UserData)
   case userDataDidChange
   case saveUserData
}

final class ProfileEditScene<Asset: AssetProtocol>: ModalDoubleStackModel<Asset>, Scenarible {
   lazy var viewModels = ProfileEditViewModels<Design>()
   lazy var contactModels = EditContactsViewModels<Design>()

   // OLD

   lazy var saveButton = Design.button.default
      .title("Сохранить")

   // MARK: - Services

   lazy var scenario: Scenario = ProfileEditScenario(
      works: ProfileEditWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ProfileEditEvents(
         contactsEvents: contactModels.work,
         saveButtonDidTap: saveButton.on(\.didTap)
      )
   )

   private lazy var works = ProfileEditWorks<Asset>()
   private var balance: Balance?

   private var currentUser: UserData?

   override func start() {
      super.start()

      //  vcModel?.sendEvent(\.setTitle, "Профиль")
      configure()

      scenario.start()
   }

   private func configure() {
      title
         .text(Design.Text.title.myProfile)

      bodyStack
         .arrangedModels([
            viewModels.editPhotoBlock,
            Design.model.common.divider,
            EditStack<Design>(title: "КОНТАКТЫ", models: [
               contactModels.surname,
               contactModels.name,
               contactModels.middlename,
               contactModels.email,
               contactModels.phone,
            ]),
            Spacer(10),
            saveButton,
            Grid.xxx.spacer,
         ])
   }

   private func saveUserData() {
      /*
       var info: [[String: Any]] = []
       var emailDic: [String: Any]
       var phoneDic: [String: Any]
       if emailId != nil {
          emailDic = [
             "contact_type": "@",
             "contact_id": self.email.models.down.view.text ?? "",
             "id": emailId
          ]
       } else {
          emailDic = [
             "contact_type": "@",
             "contact_id": self.email.models.down.view.text ?? ""
          ]
       }

       if phoneId != nil {
          phoneDic = [
             "contact_type": "P",
             "contact_id": self.phone.models.down.view.text ?? "",
             "id": phoneId
          ]
       } else {
          phoneDic = [
             "contact_type": "P",
             "contact_id": self.phone.models.down.view.text ?? ""
          ]
       }
       if emailId != nil || (emailId == nil && self.email.models.down.view.text != "") {
          info.append(emailDic)
       }
       if phoneId != nil || (phoneId == nil && self.phone.models.down.view.text != "") {
          info.append(phoneDic)
       }

       let creteFewContactsRequest = CreateFewContactsRequest(token: "",
                                                              info: info)
       self.works.createFewContacts
          .doAsync(creteFewContactsRequest)
          .onSuccess {
             print("create few contacts +")
          }
          .onFail {
             print("create few contacts -")
          }
       */

      //         let info = [
      //            "surname": self.surname.models.down.view.text ?? "",
      //            "first_name": self.firstname.models.down.view.text ?? "",
      //            "middle_name":self.middleName.models.down.view.text ?? ""
      //         ]
      //         let profileRequest = UpdateProfileRequest(token: "", id: profileId, info: info)
      //         self.works.updateProfile
      //            .doAsync(profileRequest)
      //            .onSuccess {
      //               print("update profile info")
      //            }
      //            .onFail {
      //               print("can not update profile info")
      //            }

      //         guard let emailId = emailId else {
      //            let request = CreateContactRequest(token: "",
      //                                               contactId: self.email.models.down.view.text ?? "email@gmail.com",
      //                                               contactType: "@",
      //                                               profile: profileId)
      //            self.works.createContact
      //               .doAsync(request)
      //               .onSuccess {
      //                  print("Succeessss")
      //               }
      //               .onFail {
      //                  print("FAIIIL")
      //               }
      //            print("hey yo")
      //            return
      //         }
      //
      //         self.works.updateContact
      //            .doAsync((emailId, self.email.models.down.view.text ?? "email@gmail.com"))
      //            .onSuccess {
      //               print("Succeessss")
      //            }
      //            .onFail {
      //               print("FAIIIL")
      //            }
   }

   private func setLabels(userData: UserData) {
      let profile = userData.profile
      let fullName = profile.surName.string + " " +
         profile.firstName.string + " " +
         profile.middleName.string
      viewModels.editPhotoBlock.fullAndNickName.fullName.text(fullName)
      viewModels.editPhotoBlock.fullAndNickName.nickName.text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         // userModel.models.main.url(TeamForceEndpoints.urlBase + urlSuffix)
      }

      // infoStack
//      firstname.models.down.text(profile.firstName.string)
//      surname.models.down.text(profile.surName.string)
//      middleName.models.down.text(profile.middleName.string)
//      if let contacts = profile.contacts {
//         for contact in contacts {
//            switch contact.contactType {
//            case "@":
//               email.setAll {
//                  $1.text(contact.contactId)
//               }
//            case "P":
//               phone.setAll {
//                  $1.text(contact.contactId)
//               }
//            case "T":
//               viewModels.editPhotoBlock.fullAndNickName.nickName.text("@" + contact.contactId)
//            default:
//               print("Contact error")
//            }
//         }
//      }
   }
}

extension ProfileEditScene: StateMachine {
   func setState(_ state: ProfileEditState) {
      switch state {
      case .initial:
         break
      case .userDataDidChange:
         break
      case .saveUserData:
         break
      case .error:
         break
      case .userDataDidLoad(let userData):
         contactModels.setup(userData)

         currentUser = userData
         //configureButton()
      }
   }
}
