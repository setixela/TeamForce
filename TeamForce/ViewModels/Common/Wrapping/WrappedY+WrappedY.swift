//
//  Wrapper.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import ReactiveWorks
import UIKit

final class WrappedY<VM: VMP>: BaseViewModel<StackViewExtended>,
   VMWrapper,
   Stateable
{
   typealias State = StackState

   lazy var subModel: VM = .init()

   override func start() {
      set_arrangedModels([
         subModel
      ])
   }
}

final class WrappedX<VM: VMP>: BaseViewModel<StackViewExtended>,
   VMWrapper,
   Stateable
{
   typealias State = StackState

   lazy var subModel: VM = .init()

   override func start() {
      set_axis(.horizontal)
      set_arrangedModels([
         subModel
      ])
   }
}

final class Wrapped2X<VM1: VMP, VM2: VMP>: BaseViewModel<StackViewExtended>,
   VMWrapper2,
   Stateable
{
   typealias State = StackState

   lazy var model1: VM1 = .init()
   lazy var model2: VM2 = .init()

   override func start() {
      set_axis(.horizontal)
      set_arrangedModels([
         model1,
         model2
      ])
   }
}

final class Wrapped3X<VM1: VMP, VM2: VMP, VM3: VMP>: BaseViewModel<StackViewExtended>,
                                           VMWrapper3,
                                           Stateable
{
   typealias State = StackState

  lazy var model1: VM1 = .init()
  lazy var model2: VM2 = .init()
  lazy var model3: VM3 = .init()

   override func start() {
      set_axis(.horizontal)
      set_arrangedModels([
         model1,
         model2,
         model3
      ])
   }
}
