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

final class EditContactsViewModels<Design: DSP>: BaseModel, Designable, Multiplexor {
   typealias Stock = Contacts

   var stock: Contacts = .init()
   var work: VoidWork<Contacts> = .init()

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

   // MARK: - Start

   override func start() {
      bind(event: \.didEditingChanged, of: \.surnameEditField, to: \.surname)
      bind(event: \.didEditingChanged, of: \.nameEditField, to: \.name)
      bind(event: \.didEditingChanged, of: \.middlenameEditField, to: \.middlename)
      bind(event: \.didEditingChanged, of: \.emailEditField, to: \.email)
      bind(event: \.didEditingChanged, of: \.phoneEditField, to: \.phone)
   }
}

// MARK: - Multiplexor

protocol Multiplexor: AnyObject {
   associatedtype Stock

   var work: VoidWork<Stock> { get }
   var stock: Stock { get set }
}

extension Multiplexor {
   func bind<T: Eventable, D>(event: KeyPath<T.Events, D?>,
                              of model: KeyPath<Self, T>,
                              to result: WritableKeyPath<Stock, D?>)
   {
      let model = self[keyPath: model]
      model.on(event, weak: self) {
         $0.stock[keyPath: result] = $1
         $0.work.success(result: $0.stock)
      }
   }
}

extension EditContactsViewModels: SetupProtocol {
   func setup(_ data: UserData) {
      let profile = data.profile
      surnameEditField.textField.text(profile.surName.string)
      nameEditField.textField.text(profile.firstName.string)
      middlenameEditField.textField.text(profile.middleName.string)

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

protocol SetupProtocol {
   associatedtype Data
   func setup(_ data: Data)
}
