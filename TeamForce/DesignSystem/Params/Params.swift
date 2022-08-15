//
//  ParamsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - Parameters

protocol ParamsProtocol: InitProtocol {
   //
   var cornerRadius: CGFloat { get }
   var cornerRadiusMedium: CGFloat { get }
   //
   var contentPadding: UIEdgeInsets { get }
   var titleSubtitleOffset: CGFloat { get }
   var globalTopOffset: CGFloat { get }
   //
   var buttonHeight: CGFloat { get }
   var buttonsSpacingX: CGFloat { get }
   var buttonsSpacingY: CGFloat { get }
}

struct ParamBuilder: ParamsProtocol {
   //
   var cornerRadius: CGFloat { 12 }
   var cornerRadiusMedium: CGFloat { 20 }
   //
   var contentPadding: UIEdgeInsets { .init(top: 12, left: 16, bottom: 12, right: 16) }
   var titleSubtitleOffset: CGFloat { 16 }
   var globalTopOffset: CGFloat { 24 }
   //
   var buttonHeight: CGFloat { 52 }
   var buttonsSpacingX: CGFloat { 8 }
   var buttonsSpacingY: CGFloat { 16 }
}
