//
//  BadgedViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.08.2022.
//

import ReactiveWorks
import UIKit

struct BadgeMode<WeakSelf>: WeakSelfied {
   var error: Event<WeakSelf?>?
   var normal: Event<WeakSelf?>?
}

// MARK: - Top and Bottom badged

class BadgedViewModel<VM: VMPS, Asset: AssetProtocol>: BVM<UIStackView>, Assetable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let topBadge: LabelModel = .init()
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))
      .set(.font(Design.font.caption))

   let bottomBadge: LabelModel = .init()
      .set(.text("Error label"))
      .set(.backColor(Design.color.background))
      .set(.font(Design.font.caption))

   override func start() {
      set(.axis(.vertical))
      set(.models([topBadge, mainModel, bottomBadge]))
   }
}

extension BadgedViewModel: BadgeTop, BadgeBottom {}

extension BadgedViewModel: Stateable {
   typealias State = StackState
}

extension BadgedViewModel: Modable {
   typealias Mode = BadgeMode<BadgedViewModel>
}

// MARK: - Top badged

class BadgedTopViewModel<VM: VMPS, Asset: AssetProtocol>: BVM<UIStackView>, Assetable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let topBadge: LabelModel = .init()
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))
      .set(.font(Design.font.caption))

   override func start() {
      set(.axis(.vertical))
      set(.models([topBadge, mainModel]))
   }
}

extension BadgedTopViewModel: BadgeTop {}

extension BadgedTopViewModel: Stateable {
   typealias State = StackState
}

extension BadgedTopViewModel: Modable {
   typealias Mode = BadgeMode<BadgedTopViewModel>
}

// MARK: - Bottom badged

class BadgedBottomViewModel<VM: VMPS, Asset: AssetProtocol>: BVM<UIStackView>, Assetable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let bottomBadge: LabelModel = .init()
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))
      .set(.font(Design.font.caption))

   override func start() {
      set(.axis(.vertical))
      set(.models([mainModel, bottomBadge]))
   }
}

extension BadgedBottomViewModel: BadgeBottom {}

extension BadgedBottomViewModel: Stateable {
   typealias State = StackState
}

extension BadgedBottomViewModel: Modable {
   typealias Mode = BadgeMode<BadgedBottomViewModel>
}
