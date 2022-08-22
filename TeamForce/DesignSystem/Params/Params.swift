//
//  ParamsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - Parameters

protocol ParamsProtocol: InitProtocol, Designable {
   //
   var cornerRadiusMini: CGFloat { get }
   var cornerRadiusSmall: CGFloat { get }
   var cornerRadius: CGFloat { get }
   var cornerRadiusMedium: CGFloat { get }
   //
   var borderWidth: CGFloat { get }
   //
   var titleSubtitleOffset: CGFloat { get }
   var globalTopOffset: CGFloat { get }
   //
   var buttonHeight: CGFloat { get }
   var buttonsSpacingX: CGFloat { get }
   var buttonsSpacingY: CGFloat { get }
   var buttonSecondaryHeight: CGFloat { get }
   //
   var infoFrameHeight: CGFloat { get }
   //
   var panelShadow: Shadow { get }
   var panelButtonShadow: Shadow { get }
   var panelMainButtonShadow: Shadow { get }
   // paddings
   var contentPadding: UIEdgeInsets { get }
   var contentVerticalPadding: UIEdgeInsets  { get }
   var infoFramePadding: UIEdgeInsets { get }
}

struct ParamBuilder<Design: DSP>: ParamsProtocol {
   //
   var cornerRadiusMini: CGFloat { 8 }
   var cornerRadiusSmall: CGFloat { 11 }
   var cornerRadius: CGFloat { 14 }
   var cornerRadiusMedium: CGFloat { 20 }
   //
   var borderWidth: CGFloat = 1

   var titleSubtitleOffset: CGFloat { 16 }
   var globalTopOffset: CGFloat { 24 }
   //
   var buttonHeight: CGFloat { 52 }
   var buttonsSpacingX: CGFloat { 8 }
   var buttonsSpacingY: CGFloat { 16 }
   var buttonSecondaryHeight: CGFloat { 33 }
   //
   var infoFrameHeight: CGFloat { 70 }
   //
   var panelShadow: Shadow { .init(
      radius: 20,
      color: Design.color.iconContrast,
      opacity: 0.19
   ) }
   var panelButtonShadow: Shadow { .init(
      radius: 8,
      offset: .init(x: 0, y: 10),
      color: Design.color.iconContrast,
      opacity: 0.23
   ) }
   var panelMainButtonShadow: Shadow { .init(
      radius: 8,
      offset: .init(x: 0, y: 10),
      color: Design.color.iconContrast,
      opacity: 0.23
   ) }
   // paddings
   var contentPadding: UIEdgeInsets { .init(top: 12, left: 16, bottom: 12, right: 16) }
   var contentVerticalPadding: UIEdgeInsets { .init(top: 12, left: 0, bottom: 12, right: 0) }
   var infoFramePadding: UIEdgeInsets { .init(top: 16, left: 24, bottom: 24, right: 24) }
}
