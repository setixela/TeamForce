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

   var header: [StackState]  { get }

   var bottomPanel: [StackState] { get }
   var bottomShadowedPanel: [StackState] { get }
   var bottomTabBar: [StackState] { get }

   var bodyStack: [StackState] { get }

   var inputContent: [StackState] { get }
}

struct StackStateBuilder<Design: DesignProtocol>: StackStatesProtocol {
   var `default`: [StackState] { [
      .axis(.vertical),
      .spacing(0),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background),
      .padding(UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
   ] }

   var header: [StackState] { [
      .axis(.vertical),
      .spacing(0),
      .alignment(.leading),
      .distribution(.fill),
      .padding(UIEdgeInsets(top: -32, left: 16, bottom: 0, right: 16)),
      .backColor(Design.color.backgroundBrand)
   ] }

   var bottomPanel: [StackState] { [
      .axis(.vertical),
      .spacing(Design.params.buttonsSpacingY),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background),
      .padding(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
   ] }

   var inputContent: [StackState] { [
      .axis(.horizontal),
      .spacing(10),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background),
      .cornerRadius(Design.params.cornerRadius),
      .borderWidth(1),
      .borderColor(Design.color.boundary),
      .padding(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
   ] }

   var bottomShadowedPanel: [StackState] { [
      .axis(.vertical),
      .spacing(Design.params.buttonsSpacingY),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background),
      .padding(UIEdgeInsets(top: 30, left: 16, bottom: 16, right: 16)),
      .cornerRadius(Design.params.cornerRadiusMedium),
      .shadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
   ] }

   var bottomTabBar: [StackState] { [
      .axis(.horizontal),
      .distribution(.fillEqually),
      .padding(.zero),
      .spacing(0)
   ] }

   var bodyStack: [StackState] { [
      .axis(.vertical),
      .alignment(.fill),
      .distribution(.fill),
      .backColor(Design.color.background),
      .padding(UIEdgeInsets(top: 30, left: 16, bottom: 16, right: 16)),
      .cornerRadius(Design.params.cornerRadiusMedium),
      .shadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
   ] }
}
