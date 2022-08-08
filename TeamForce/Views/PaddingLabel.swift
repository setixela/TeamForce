//
//  PaddingLabel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

protocol Marginable {
   var padding: UIEdgeInsets { get set }
}

final class PaddingLabel: UILabel, Marginable {
   var padding: UIEdgeInsets = .init()

   override public func draw(_ rect: CGRect) {
      drawText(in: rect.inset(by: padding))
   }

   override var intrinsicContentSize: CGSize {
      guard let text = text else { return super.intrinsicContentSize }

      var contentSize = super.intrinsicContentSize
      var textWidth: CGFloat = contentSize.width
      var insetsHeight: CGFloat = 0.0
      var insetsWidth: CGFloat = 0.0

      insetsWidth += padding.left + padding.right
      insetsHeight += padding.top + padding.bottom

      textWidth -= insetsWidth

      let newSize = text.boundingRect(with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
                                      options: [.usesLineFragmentOrigin],
                                      attributes: [NSAttributedString.Key.font: font!],
                                      context: nil)

      contentSize.height = ceil(newSize.size.height) + insetsHeight
      contentSize.width = ceil(newSize.size.width) + insetsWidth

      return contentSize
   }
}

/// Description
final class PaddingTextField: UITextField, Marginable {
   // padding extension
   var padding: UIEdgeInsets = .init()

   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }

   override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }

   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
}

final class PaddingImageView: UIImageView, Marginable {
   var padding: UIEdgeInsets = .init()

   override var alignmentRectInsets: UIEdgeInsets {
      return .init(top: -padding.top,
                   left: -padding.left,
                   bottom: -padding.bottom,
                   right: -padding.right)
   }
}

final class PaddingView: UIView, Marginable {
   var padding: UIEdgeInsets = .init()

   override var alignmentRectInsets: UIEdgeInsets {
      return .init(top: -padding.top,
                   left: -padding.left,
                   bottom: -padding.bottom,
                   right: -padding.right)
   }
}
