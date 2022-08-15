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
      setModels([
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
      setAxis(.horizontal)
      setModels([
         subModel
      ])
   }
}
