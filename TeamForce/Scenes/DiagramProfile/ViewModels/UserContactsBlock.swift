//
//  UserContactsBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserContactsBlock

final class UserContactsBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var title = LabelModel()
      .set(Design.state.label.body1)
      .text("Контактные данные")

   private lazy var surname = ProfileTitleBody<Design>
   { $0.title.text("Фамилия") }
   private lazy var name = ProfileTitleBody<Design>
   { $0.title.text("Имя") }
   private lazy var middlename = ProfileTitleBody<Design>
   { $0.title.text("Отчество") }
   private lazy var email = ProfileTitleBody<Design>
   { $0.title.text("Корпоративная почта") }
   private lazy var phone = ProfileTitleBody<Design>
   { $0.title.text("Мобильный номер") }
   private lazy var birthDate = ProfileTitleBody<Design>
   { $0.title.text("День рождения") }

   override func start() {
      super.start()

      spacing(16)
      arrangedModels(
         title,
         surname,
         name,
         middlename,
         email,
         phone,
         birthDate
      )
   }
}

extension UserContactsBlock: StateMachine {
   func setState(_ state: UserContactData) {
      surname.setBody(state.surname)
      name.setBody(state.name)
      middlename.setBody(state.patronymic)
      email.setBody(state.corporateEmail)
      phone.setBody(state.corporateEmail)
      birthDate.setBody(state.dateOfBirth)
   }
}
