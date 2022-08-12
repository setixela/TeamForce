//
//  ParamsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import UIKit
import ReactiveWorks

// MARK: - Parameters

protocol ParamsProtocol: InitProtocol {
   //
   static var cornerRadius: CGFloat { get }
   static var cornerRadiusMedium: CGFloat { get }
   //
   static var contentPadding: UIEdgeInsets { get }
   static var titleSubtitleOffset: CGFloat { get }
   static var globalTopOffset: CGFloat { get }
   //
   static var buttonHeight: CGFloat { get }
   static var buttonsSpacingX: CGFloat { get }
   static var buttonsSpacingY: CGFloat { get }
}

struct GlobalParameters: ParamsProtocol {
   //
   static var cornerRadius: CGFloat { 15 }
   static var cornerRadiusMedium: CGFloat { 20 }
   //
   static var contentPadding: UIEdgeInsets { .init(top: 12, left: 16, bottom: 12, right: 16) }
   static var titleSubtitleOffset: CGFloat { 16 }
   static var globalTopOffset: CGFloat { 24 }
   //
   static var buttonHeight: CGFloat { 50 }
   static var buttonsSpacingX: CGFloat { 8 }
   static var buttonsSpacingY: CGFloat { 24 }
}
