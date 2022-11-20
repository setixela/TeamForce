//
//  EditContactsViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.09.2022.
//

import ReactiveWorks

final class EditContactsViewModels<Design: DSP>: BaseModel, Designable, Multiplexor {
   typealias Stock = Contacts

   var stock: Contacts = .init()
   var work: WorkVoid<Contacts> = .init()

   lazy var surnameEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Фамилия")
         $1.placeholder("Фамилия")
      }

   lazy var nameEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Имя")
         $1.placeholder("Имя")
      }

   lazy var middlenameEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Отчество")
         $1.placeholder("Отчество")
      }

   lazy var emailEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Корпоративная почта")
         $1.placeholder("Корпоративная почта")
      }

   lazy var phoneEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Мобильный номер")
         $1.placeholder("Мобильный номер")
      }
   
   lazy var telegramEditField = Design.model.profile.titledTextField
      .setAll {
         $0.text("Имя пользователя")
         $1.placeholder("Имя пользователя")
      }

   // MARK: - Start

   override func start() {
      bind(event: \.didEditingChanged, of: \.surnameEditField, to: \.surname)
      bind(event: \.didEditingChanged, of: \.nameEditField, to: \.name)
      bind(event: \.didEditingChanged, of: \.middlenameEditField, to: \.middlename)
      bind(event: \.didEditingChanged, of: \.emailEditField, to: \.email)
      bind(event: \.didEditingChanged, of: \.phoneEditField, to: \.phone)
      bind(event: \.didEditingChanged, of: \.telegramEditField, to: \.telegram)
   }
}

extension EditContactsViewModels: SetupProtocol {
   func setup(_ data: UserData) {
      let profile = data.profile
      surnameEditField.textField.text(profile.surName.string)
      nameEditField.textField.text(profile.firstName.string)
      middlenameEditField.textField.text(profile.middleName.string)
      telegramEditField.textField.text(profile.tgName)

      if let contacts = profile.contacts {
         for contact in contacts {
            switch contact.contactType {
            case "@":
               emailEditField.textField
                  .text(contact.contactId)
            case "P":
               phoneEditField.textField
                  .text(contact.contactId)
            default:
               print("Contact error")
            }
         }
      }
   }
}
