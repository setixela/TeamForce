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

typealias ASP = AssetProtocol

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


