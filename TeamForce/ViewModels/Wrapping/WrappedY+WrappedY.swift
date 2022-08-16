//
//  Wrapper.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import ReactiveWorks
import UIKit

final class WrappedY<VM: VMP>: BaseViewModel<UIStackView>,
   VMWrapper,
   Stateable
{
   typealias State = StackState

   var subModel: VM = .init()

   override func start() {
      set_models([
         subModel
      ])
   }
}

final class WrappedX<VM: VMP>: BaseViewModel<UIStackView>,
   VMWrapper,
   Stateable
{
   typealias State = StackState

   var subModel: VM = .init()

   override func start() {
      set_axis(.horizontal)
      set_models([
         subModel
      ])
   }
}
