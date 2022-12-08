//
//  StatusSelectorWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

final class StatusSelectorStorage: InitProtocol {
   init() {}

   var statusList: [UserStatus] = []
}

final class StatusSelectorWorks<Asset: ASP>: BaseWorks<StatusSelectorStorage, Asset> {}

extension StatusSelectorWorks: UserStatusWorksProtocol {}

protocol UserStatusWorksProtocol: WorksProtocol, TempStorage where
   Temp: StatusSelectorStorage
{
   var loadUserStatusList: Work<Void, Void> { get }
   //
   var getUserStatusList: Work<Void, [UserStatus]> { get }
   var getUserStatusByIndex: Work<Int, UserStatus> { get }
}

extension UserStatusWorksProtocol {
   var loadUserStatusList: Work<Void, Void> {.init { work in
      //TODO: - Fish
      Self.store.statusList = UserStatus.allCases
      work.success()
   }.retainBy(retainer) }
   //
   var getUserStatusList: Work<Void, [UserStatus]> { .init { work in
      work.success(Self.store.statusList)
   }.retainBy(retainer) }

   var getUserStatusByIndex: Work<Int, UserStatus> { .init { work in
      work.success(Self.store.statusList[work.unsafeInput])
   }.retainBy(retainer) }
}


