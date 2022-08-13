//
//  StackStateBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol StackStatesProtocol: InitProtocol, Designable {
   var `default`: [StackState] { get }
   var bottomPanel: [StackState] { get }
}

struct StackStateBuilder<Design: DesignProtocol>: StackStatesProtocol {
   var `default`: [StackState] { [
      .axis(.vertical),
      .spacing(0),
      .alignment(.fill),
      .distribution(.fill),
      .padding(UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
   ] }

   var bottomPanel: [StackState] { [
      .axis(.vertical),
      .spacing(Design.params.buttonsSpacingY),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background2),
      .padding(UIEdgeInsets(top: 24, left: 16, bottom: 46, right: 16))
   ] }
}
