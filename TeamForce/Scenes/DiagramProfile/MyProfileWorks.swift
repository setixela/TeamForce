//
//  DiagramProfileWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 05.12.2022.
//

import ReactiveWorks

final class ProfileStorage: InitProtocol {
   var userData: UserData?
}

final class MyProfileWorks<Asset: ASP>: BaseWorks<ProfileStorage, Asset>, DiagramProfileWorksProtocol,
   GetProfileWorksProtocol,
   GetMyProfileWorksProtocol
{
   lazy var apiUseCase = Asset.apiUseCase
}

// MARK: - Common works

protocol DiagramProfileWorksProtocol {
   var getDiagramData: Work<Void, CircleGraphs> { get }
}

extension DiagramProfileWorksProtocol {
   var getDiagramData: Work<Void, CircleGraphs> {
      .init { work in
         let graphs = CircleGraphs(graphs: [
            .init(percent: 0.25, color: .red),
            .init(percent: 0.25, color: .blue),
            .init(percent: 0.5, color: .green),
         ])

         work.success(graphs)
      }
   }
}

protocol GetProfileWorksProtocol: StoringWorksProtocol, Assetable
where
Temp: ProfileStorage,
Asset: AssetProtocol
{
   var apiUseCase: ApiUseCase<Asset> { get }
   var getProfileById: Work<ProfileID, UserData> { get }
}

extension GetProfileWorksProtocol {
   var getProfileById: Work<ProfileID, UserData> {
      .init { [weak self] work in
         let input = work.unsafeInput

         self?.apiUseCase.getProfileById
            .doAsync(input)
            .onSuccess {
               Self.store.userData = $0
            }
            .onFail {
               print("failed to load profile")
            }
      }.retainBy(retainer)
   }
}

protocol GetMyProfileWorksProtocol: StoringWorksProtocol, Assetable
where
Temp: ProfileStorage,
Asset: AssetProtocol
{
   var apiUseCase: ApiUseCase<Asset> { get }
   var getMyProfile: Work<Void, UserData> { get }
}

extension GetMyProfileWorksProtocol {
   var getMyProfile: Work<Void, UserData> {
      .init { [weak self] work in
         self?.apiUseCase.loadProfile
            .doAsync()
            .onSuccess {
               Self.store.userData = $0
               work.success($0)
            }
            .onFail {
               print("failed to load profile")
               work.fail()
            }
      }.retainBy(retainer)
   }
}
