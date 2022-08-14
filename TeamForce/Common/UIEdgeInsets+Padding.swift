//
//  UIEdgeInsets+Padding.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 14.08.2022.
//

import UIKit

extension UIEdgeInsets {
   static func left(_ offset: CGFloat) -> UIEdgeInsets {
      UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
   }
}
