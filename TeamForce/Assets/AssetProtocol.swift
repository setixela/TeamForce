//
//  AssetProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.06.2022.
//

import ReactiveWorks

protocol ServiceProtocol: InitProtocol {
   var apiEngine: ApiEngineProtocol { get }
   var safeStringStorage: StringStorageProtocol { get }
}

protocol AssetProtocol: AssetRoot
   where
   Scene: ScenesProtocol,
   Service: ServiceProtocol,
   Design: DesignProtocol
{
   static var router: MainRouter<Self>? { get set }

   typealias Asset = Self
   typealias Text = Design.Text
}

extension AssetProtocol {
   static var apiUseCase: ApiUseCase<Asset> {
      .init()
   }

   static var storageUseCase: StorageWorks<Asset> {
      .init()
   }
}

protocol ScenesProtocol: InitProtocol {
   var digitalThanks: SceneModelProtocol { get }
   var login: SceneModelProtocol { get }
   var main: SceneModelProtocol { get }
   var profile: SceneModelProtocol { get }
   var profileEdit: SceneModelProtocol { get }

   // plays
   var playground: SceneModelProtocol { get }
}

protocol ModelFabric: Designable {
   associatedtype Label: InitProtocol
   associatedtype Other: InitProtocol

   associatedtype Designed: DesignedFabricProtocol
   associatedtype Semantic: SemanticFabricProtocol
}

struct Fabric<Design: DSP>: ModelFabric {
   typealias Label = LabelP
   typealias Other = OtherP
   typealias Designed = DesignedFabric<Design>
   typealias Semantic = SemanticFabric<Design>
}

struct LabelP: InitProtocol {}
struct OtherP: InitProtocol {
   var imagePicker: ImagePickerViewModel { .init() }
}

struct LabelDSP<Design: DSP>: InitProtocol, Designable {
   var titleSubtitleX: TitleSubtitleX<Design> { .init() }
   var titleSubtitleY: TitleSubtitleY<Design> { .init() }
}

struct ButtonDSP<Design: DSP>: InitProtocol, Designable {}
struct SemanticFabric<Design: DSP>: SemanticFabricProtocol, Designable {}

protocol ModelDSP {}
protocol DesignedFabricProtocol: InitProtocol, Designable {
   associatedtype LabelSystem: InitProtocol
   associatedtype ButtonSystems: InitProtocol
}

struct DesignedFabric<Design: DSP>: DesignedFabricProtocol {
   typealias ButtonSystems = ButtonDSP<Design>
   typealias LabelSystem = LabelDSP<Design>
}

protocol SemanticFabricProtocol: InitProtocol {
//   associatedtype Login
//   associatedtype Feed
//   associatedtype Main
//   associatedtype History
//   associatedtype Transact
}
