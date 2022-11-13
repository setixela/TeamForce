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
   var commonSideOffset: CGFloat { get }
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
   var buttonHeightSmall: CGFloat { get }
   var buttonHeightMini: CGFloat { get }

   var buttonsSpacingX: CGFloat { get }
   var buttonsSpacingY: CGFloat { get }

   //
   var infoFrameHeight: CGFloat { get }
   //
   var panelShadow: Shadow { get }
   var panelButtonShadow: Shadow { get }
   var panelMainButtonShadow: Shadow { get }
   var cellShadow: Shadow { get }
   var profileUserPanelShadow: Shadow { get }
   // paddings
   var contentPadding: UIEdgeInsets { get }
   var textViewPadding: UIEdgeInsets { get }
   var contentVerticalPadding: UIEdgeInsets { get }
   var cellContentPadding: UIEdgeInsets { get }
   var userInfoHeaderPadding: UIEdgeInsets { get }
   var infoFramePadding: UIEdgeInsets { get }
}

struct ParamBuilder<Design: DSP>: ParamsProtocol {
   //
   var commonSideOffset: CGFloat { 16 }
   //
   var cornerRadiusMini: CGFloat { 8 }
   var cornerRadiusSmall: CGFloat { 12 }
   var cornerRadius: CGFloat { 14 }
   var cornerRadiusMedium: CGFloat { 20 }
   //
   var borderWidth: CGFloat = 1

   var titleSubtitleOffset: CGFloat { 16 }
   var globalTopOffset: CGFloat { 24 }
   //
   var buttonHeight: CGFloat { 52 }
   var buttonHeightSmall: CGFloat { 38 }
   var buttonHeightMini: CGFloat { 24 }
   //
   var buttonsSpacingX: CGFloat { 8 }
   var buttonsSpacingY: CGFloat { 16 }
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
   var cellShadow: Shadow { .init(
      radius: 7,
      offset: .init(x: 0, y: 4),
      color: Design.color.iconContrast,
      opacity: 0.12
   ) }
   var profileUserPanelShadow: Shadow { .init(
      radius: 12,
      offset: .init(x: 0, y: 12),
      color: UIColor(red: 0.794, green: 0.816, blue: 0.858, alpha: 0.25), // Design.color.iconContrast,
      opacity: 1.0
   ) }
   // paddings
   var contentPadding: UIEdgeInsets { .init(top: 12, left: commonSideOffset, bottom: 12, right: commonSideOffset) }
   var contentVerticalPadding: UIEdgeInsets { .init(top: 12, left: 0, bottom: 12, right: 0) }

   var textViewPadding: UIEdgeInsets {
      .init(top: 12, left: 10, bottom: 12, right: 10)
   }

   var cellContentPadding: UIEdgeInsets { .init(top: 12, left: commonSideOffset, bottom: 12, right: commonSideOffset) }
   var userInfoHeaderPadding: UIEdgeInsets { .init(top: 12, left: 12, bottom: 12, right: 12) }
   var infoFramePadding: UIEdgeInsets { .init(top: 16, left: 24, bottom: 24, right: 24) }
}
