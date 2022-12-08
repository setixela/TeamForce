//
//  DiagramProfileVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.12.2022.
//

import ReactiveWorks

// MARK: - MyProfileVM

final class MyProfileVM<Design: DSP>: ScrollViewModelY, Designable {
   lazy var userBlock = ProfileUserBlock<Design>()
   lazy var userNameBlock = UserNameBlock<Design>()
   lazy var diagramBlock = TagsPercentBlock<Design>()
   lazy var userStatusBlock = UserStatusBlock<Design>()
   lazy var userContactsBlock = UserContactsBlock<Design>()
   lazy var workingPlaceBlock = WorkingPlaceBlock<Design>()
   lazy var userRoleBlock = UserRoleBlock<Design>()
   lazy var locationBlock = UserLocationBlock<Design>()

   private lazy var userSettingsBlock = UserSettingsBlock<Design>()

   override func start() {
      super.start()

      set(.arrangedModels([
         userBlock,
         userNameBlock,
         userStatusBlock,
         diagramBlock,
         userContactsBlock,
         workingPlaceBlock,
         userRoleBlock,
         locationBlock,
         userSettingsBlock,
         Spacer(48)
      ]))
      set(.spacing(16))
      set(.padding(.horizontalOffset(16)))
   }
}
