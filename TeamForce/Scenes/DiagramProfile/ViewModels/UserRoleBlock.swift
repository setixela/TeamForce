//
//  UserRoleBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserRoleBlock

final class UserRoleBlock<Design: DSP>: ProfileStackModel<Design> {
   private lazy var role = ProfileTitleBody<Design>
   { $0.title.text("Роль") }

   override func start() {
      super.start()

      spacing(16)
      arrangedModels(
         role
      )
   }
}

extension UserRoleBlock: StateMachine {
   func setState(_ state: UserRoleData) {
      role.setBody(state.role)
   }
}
