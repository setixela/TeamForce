//
//  MainWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation
import ReactiveWorks

final class MainTemptore: InitProtocol {}

final class MainBackstage<Asset: AssetProtocol>: BaseSceneWorks<MainTemptore, Asset> {}