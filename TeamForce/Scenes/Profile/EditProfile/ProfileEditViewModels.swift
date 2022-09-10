//
//  ProfileEditSceneViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.09.2022.
//

import Foundation
import ReactiveWorks

final class ProfileEditViewModels<Design: DSP>: Designable {
   lazy var editPhotoBlock = Design.model.profile.editPhotoBlock
}

struct EditContactsEvents {
   let surname: VoidWork<String>
   let name: VoidWork<String>
   let middlename: VoidWork<String>
   let email: VoidWork<String>
   let phone: VoidWork<String>
}

final class EditContactsViewModels<Design: DSP>: BaseModel, Designable {

   lazy var work: VoidWork<Contacts> = .init()

   private var contacts = Contacts()

   lazy var surname = Design.model.profile.titledTextField
      .setAll {
         $0.text("Фамилия")
         $1.placeholder("Фамилия")
      }

   lazy var name = Design.model.profile.titledTextField
      .setAll {
         $0.text("Имя")
         $1.placeholder("Имя")
      }

   lazy var middlename = Design.model.profile.titledTextField
      .setAll {
         $0.text("Отчество")
         $1.placeholder("Отчество")
      }

   lazy var email = Design.model.profile.titledTextField
      .setAll {
         $0.text("Корпоративная почта")
         $1.placeholder("Корпоративная почта")
      }

   lazy var phone = Design.model.profile.titledTextField
      .setAll {
         $0.text("Мобильный номер")
         $1.placeholder("Мобильный номер")
      }

   // MARK: - Start

   override func start() {
      surname.models.down.on(\.didEditingChanged, weak: self) {
         $0.contacts.surname = $1
         $0.work.success(result: $0.contacts)
      }
      name.models.down.on(\.didEditingChanged, weak: self) {
         $0.contacts.name = $1
         $0.work.success(result: $0.contacts)
      }
      middlename.models.down.on(\.didEditingChanged, weak: self) {
         $0.contacts.middlename = $1
         $0.work.success(result: $0.contacts)
      }
      email.models.down.on(\.didEditingChanged, weak: self) {
         $0.contacts.email = $1
         $0.work.success(result: $0.contacts)
      }
      phone.models.down.on(\.didEditingChanged, weak: self) {
         $0.contacts.phone = $1
         $0.work.success(result: $0.contacts)
      }
   }

//   func bind<T>(_ models: Any) -> () -> T {
//
//   }
}

//protocol Bindable {
//   var event: Work<
//}
//
//protocol Binder {
//   associatedtype Result
//}
//
//extension Binder {
//   func bind<B: Bindable>(_ key: KeyPath<B, B>, to result: KeyPath<Result, Result>) {
//
//   }
//}

extension EditContactsViewModels: SetupProtocol {
   func setup(_ data: UserData) {
      let profile = data.profile
      surname.models.down.text(profile.surName.string)
      name.models.down.text(profile.firstName.string)
      middlename.models.down.text(profile.middleName.string)

      if let contacts = profile.contacts {
         for contact in contacts {
            switch contact.contactType {
            case "@":
               email.setAll {
                  $1.text(contact.contactId)
               }
            case "P":
               phone.setAll {
                  $1.text(contact.contactId)
               }
            default:
               print("Contact error")
            }
         }
      }
   }
}

protocol SetupProtocol {
   associatedtype Data
   func setup(_ data: Data)
}
