//
//  AligningModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks
import UIKit

extension ViewModelProtocol {
   func centeredX() -> CenteredX<Self> {
      CenteredX(self)
   }

   func centeredY() -> CenteredY<Self> {
      CenteredY(self)
   }

   func lefted() -> Lefted<Self> {
      Lefted(self)
   }

   func righted() -> Righted<Self> {
      Righted(self)
   }
}

// Центрирует в .fill стеках
final class CenteredX<VM: VMP>: BaseViewModel<UIStackView>, Stateable, VMWrapper {
   typealias State = StackState

   lazy var subModel = VM()

   override func start() {
      set(.axis(.vertical))
      set(.alignment(.center))
      set(.distribution(.equalSpacing))
      set(.models([
         subModel
      ]))
   }
}

// Центрирует в .fill стеках
final class CenteredY<VM: VMP>: BaseViewModel<UIStackView>, Stateable, VMWrapper {
   typealias State = StackState

   lazy var subModel = VM()

   override func start() {
      set(.axis(.horizontal))
      set(.alignment(.center))
      set(.distribution(.equalSpacing))
      set(.models([
         subModel
      ]))
   }
}

// обжимает модель с двух сторон, для увода влево в .fill стеках
final class Lefted<VM: VMP>: BaseViewModel<UIStackView>, Stateable, VMWrapper {
   typealias State = StackState

   lazy var subModel = VM()

   override func start() {
      set(.axis(.horizontal))
      set(.distribution(.fill))
      set(.models([
         subModel,
         Spacer()
      ]))
   }
}

// обжимает модель с двух сторон, для увода вправо в .fill стеках
final class Righted<VM: VMP>: BaseViewModel<UIStackView>, Stateable, VMWrapper {
   typealias State = StackState

   lazy var subModel = VM()

   override func start() {
      set(.axis(.horizontal))
      set(.distribution(.fill))
      set(.models([
         Spacer(),
         subModel
      ]))
   }
}
