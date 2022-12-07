//
//  DiagramProfileWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 05.12.2022.
//

import CoreLocation
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
   //
   var loadMyProfile: Work<Void, Void> { get }
   //
   var getUserStatus: Work<Void, UserStatus> { get }
   var getUserContacts: Work<Void, UserContactData> { get }
   var getUserWorkData: Work<Void, UserWorkData> { get }
   var getUserRoleData: Work<Void, UserRoleData> { get }
   var getUserLocationData: Work<Void, UserLocationData> { get }
}

extension GetMyProfileWorksProtocol {
   var loadMyProfile: Work<Void, Void> { .init { [weak self] work in
      self?.apiUseCase.loadProfile
         .doAsync()
         .onSuccess {
            Self.store.userData = $0
            work.success()
         }
         .onFail {
            print("failed to load profile")
            work.fail()
         }
   }.retainBy(retainer) }

   // TODO: - Default Lorem ipsum
   var getUserStatus: Work<Void, UserStatus> { .init { work in
      work.success(UserStatus.allCases.randomElement() ?? .office)
   }.retainBy(retainer) }

   // TODO: - Default Lorem ipsum
   var getUserContacts: Work<Void, UserContactData> { .init { work in
      guard let userData = Self.store.userData else { work.fail(); return }
      let profile = userData.profile
      let contacts = UserContactData(
         name: profile.firstName,
         surname: profile.surName,
         patronymic: profile.middleName,
         corporateEmail: userData.userEmail,
         mobilePhone: userData.userPhone,
         dateOfBirth: "24 августа 1995 г." // TODO: - Lorem ipsum
      )

      work.success(contacts)
   } }

   var getUserWorkData: Work<Void, UserWorkData> { .init { work in
      guard let userData = Self.store.userData else { work.fail(); return }

      let workPlaceData = UserWorkData(
         company: userData.profile.organization,
         jobTitle: userData.profile.jobTitle
      )

      work.success(workPlaceData)
   } }

   var getUserRoleData: Work<Void, UserRoleData> { .init { work in
//      guard
//         let userData = Self.store.userData,
//         let privelege = userData.privileged.first
//      else { work.fail(); return }
//
//      let userRoleData = UserRoleData(role: privelege.roleName)

      let userRoleData = UserRoleData(role: "Администратор") // TODO: - Fish yet

      work.success(userRoleData)
   } }

   var getUserLocationData: Work<Void, UserLocationData> { .init { _ in } }
}

enum UserStatus: CaseIterable {
   case office
   case vacation
   case remote
   case sickLeave
}

struct UserContactData {
   let name: String?
   let surname: String?
   let patronymic: String?
   let corporateEmail: String?
   let mobilePhone: String?
   let dateOfBirth: String?
}

struct UserWorkData {
   let company: String
   let jobTitle: String?
}

struct UserRoleData {
   let role: String
}

struct UserLocationData {
   let locationName: String
   let geoPosition: CLLocationCoordinate2D
}
