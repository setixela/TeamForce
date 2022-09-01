//
//  Shadow.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 25.08.2022.
//

import UIKit

struct Shadow {
   let radius: CGFloat
   let offset: CGPoint
   let color: UIColor
   let opacity: CGFloat

   init(
      radius: CGFloat = 1,
      offset: CGPoint = .zero,
      color: UIColor = .label,
      opacity: CGFloat = 1
   ) {
      self.radius = radius
      self.offset = offset
      self.color = color
      self.opacity = opacity
   }

   static var noShadow: Shadow {
      Shadow(radius: 0, offset: .zero, color: .clear, opacity: 0)
   }
}
