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

class BadgedViewModel<VM: VMPS, Design: DSP>: BVM<StackViewExtended>, Designable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let topBadge: LabelModel = .init()
      .set(Design.state.label.caption)
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))


   let bottomBadge: LabelModel = .init()
      .set(Design.state.label.caption)
      .set(.text("Error label"))
      .set(.backColor(Design.color.background))


   override func start() {
      set(.axis(.vertical))
      set(.models([topBadge, mainModel, bottomBadge]))
   }
}

extension BadgedViewModel: BadgeTop, BadgeBottom {}

extension BadgedViewModel: Stateable {
   typealias State = StackState
}

extension BadgedViewModel: SelfModable {
   typealias Mode = BadgeMode<BadgedViewModel>
}

// MARK: - Top badged

class BadgedTopViewModel<VM: VMPS, Asset: AssetProtocol>: BVM<StackViewExtended>, Assetable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let topBadge: LabelModel = .init()
      .set(Design.state.label.caption)
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))

   override func start() {
      set(.axis(.vertical))
      set(.models([topBadge, mainModel]))
   }
}

extension BadgedTopViewModel: BadgeTop {}

extension BadgedTopViewModel: Stateable {
   typealias State = StackState
}

extension BadgedTopViewModel: SelfModable {
   typealias Mode = BadgeMode<BadgedTopViewModel>
}

// MARK: - Bottom badged

class BadgedBottomViewModel<VM: VMPS, Asset: AssetProtocol>: BVM<StackViewExtended>, Assetable {
   var modes: Mode = .init()

   let mainModel: VM = .init()

   let bottomBadge: LabelModel = .init()
      .set(.text("Title label"))
      .set(.backColor(Design.color.background))
      .set(Design.state.label.caption)

   override func start() {
      set(.axis(.vertical))
      set(.models([mainModel, bottomBadge]))
   }
}

extension BadgedBottomViewModel: BadgeBottom {}

extension BadgedBottomViewModel: Stateable {
   typealias State = StackState
}

extension BadgedBottomViewModel: SelfModable {
   typealias Mode = BadgeMode<BadgedBottomViewModel>
}
