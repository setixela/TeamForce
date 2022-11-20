//
//  ChallengeDetailsWorks+Checks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import ReactiveWorks

extension ChallengeDetailsWorks {
   var amIOwnerCheck: Work<Void, Void> { .init { work in
      guard
         let profileId = Self.store.currentUserId,
         let creatorId = Self.store.challenge?.creatorId
      else { work.fail(); return }

      if profileId == creatorId {
         work.success(())
      } else {
         work.fail()
      }
   }.retainBy(retainer) }
}
