//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

protocol DoubleStackProtocol {
   var bodyStack: StackModel { get }
   var footerStack: StackModel { get }
}

protocol TripleStackProtocol {
   var headerStack: StackModel { get }
   var bodyStack: StackModel { get }
   var footerStack: StackModel { get }
}

protocol QuadroStackProtocol {
   var headerStack: StackModel { get }
   var bodyStack: StackModel { get }
   var captionStack: StackModel { get }
   var footerStack: StackModel { get }
}

class DoubleStacksModel: BaseViewModel<StackViewExtended>, DoubleStackProtocol {
   let bodyStack = StackModel(.axis(.vertical),
                              .alignment(.fill),
                              .distribution(.fill))
   let footerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))

   override func start() {
      set(.axis(.vertical))
      set(.alignment(.fill))
      set(.distribution(.fill))
      set(.arrangedModels([
         bodyStack,
         footerStack
      ]))
   }
}

extension DoubleStacksModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}

class TripleStacksModel: BaseViewModel<StackViewExtended>, TripleStackProtocol {
   let headerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))
   let bodyStack = StackModel(.axis(.vertical),
                              .alignment(.fill),
                              .distribution(.fill))
   let footerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))

   override func start() {
      axis(.vertical)
      alignment(.fill)
      distribution(.fill)
      arrangedModels([
         headerStack,
         bodyStack,
         footerStack
      ])
   }
}

extension TripleStacksModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}

class QuadroStacksModel: BaseViewModel<StackViewExtended>, QuadroStackProtocol {
   let headerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))
   let bodyStack = StackModel(.axis(.vertical),
                              .alignment(.fill),
                              .distribution(.fill))
   let captionStack = StackModel(.axis(.vertical),
                                 .alignment(.fill),
                                 .distribution(.fill))
   let footerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))

   override func start() {
      axis(.vertical)
      alignment(.fill)
      distribution(.fill)
      arrangedModels([
         headerStack,
         bodyStack,
         captionStack,
         footerStack
      ])
   }
}

extension QuadroStacksModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}
