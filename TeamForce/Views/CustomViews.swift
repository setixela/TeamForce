//
//  PaddingLabel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import ReactiveWorks
import UIKit

protocol Marginable {
   var padding: UIEdgeInsets { get set }
}

// MARK: - PaddingLabel -------------------------

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

// MARK: - PaddingTextField -------------------------

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

// MARK: - PaddinPaddingImageViewgLabel -------------------------

final class PaddingImageView: UIImageView, Marginable {
   var padding: UIEdgeInsets = .init()

   override var alignmentRectInsets: UIEdgeInsets {
      return .init(top: -padding.top,
                   left: -padding.left,
                   bottom: -padding.bottom,
                   right: -padding.right)
   }
}

// MARK: - PaddingView -------------------------

final class PaddingView: UIView, Marginable {
   var padding: UIEdgeInsets = .init()

   override var alignmentRectInsets: UIEdgeInsets {
      return .init(top: -padding.top,
                   left: -padding.left,
                   bottom: -padding.bottom,
                   right: -padding.right)
   }
}

// MARK: - StackViewExtendeed -------------------------

final class StackViewExtended: UIStackView, Communicable {
   struct Events: InitProtocol {
      var willAppear: Event<Void>?
      var willDisappear: Event<Void>?
   }

   var events: Events = .init()

   weak var backView: UIView?

   override init(frame: CGRect) {
      super.init(frame: frame)

      clipsToBounds = false
      layer.masksToBounds = false
   }

   @available(*, unavailable)
   required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   override func layoutSubviews() {
      super.layoutSubviews()

      guard let backView = backView else {
         return
      }

      sendSubviewToBack(backView)
   }

   override func willMove(toSuperview newSuperview: UIView?) {
      super.willMove(toSuperview: newSuperview)

      if newSuperview == nil {
         sendEvent(\.willDisappear)
      } else {
         sendEvent(\.willAppear)
      }
   }
}
