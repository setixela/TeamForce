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

   var isOnlyDigitsMode = false

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

import AlamofireImage

protocol AlamoLoader {
   var downloader: ImageDownloader { get }
}

final class PaddingImageView: UIImageView, Marginable, AlamoLoader {
   var padding: UIEdgeInsets = .init()

   lazy var downloader = ImageDownloader()

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

      axis = .vertical
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

   override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      if !clipsToBounds, !isHidden, alpha > 0 {
         let button = subviews.flatMap {
            $0.subviews.flatMap { $0.subviews }
         }
         .filter {
            $0 is UIButton
         }
         .first(where: {
            let subPoint = $0.convert(point, from: self)
            return $0.hitTest(subPoint, with: event) != nil
         })

         if button != nil {
            return button
         }
      }

      return super.hitTest(point, with: event)
   }
}

// MARK: - ButtonExtended(UIButton) -------------------------

final class ButtonExtended: UIButton, AlamoLoader {
   lazy var downloader = ImageDownloader()

   var isVertical = false

   override init(frame: CGRect) {
      super.init(frame: frame)

      imageView?.contentMode = .scaleAspectFit
   }

   override func layoutSubviews() {
      super.layoutSubviews()

      if isVertical {
         setButtonVertical()
      }
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   private func setButtonVertical() {
      let titleSize = titleLabel?.frame.size ?? .zero
      let imageSize = imageView?.frame.size ?? .zero
      let spacing: CGFloat = 6.0
      imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
      titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
   }
}

// MARK: - Tap animator -------------------------

protocol ButtonTapAnimator: UIViewModel {}

extension ButtonTapAnimator {
   func animateTap() {
      let frame = uiView.frame
      uiView.frame = uiView.frame.inset(by: .init(top: 3, left: 2, bottom: -2, right: 3))
      UIView.animate(withDuration: 0.3) {
         self.uiView.frame = frame
      }
   }

   func animateTapWithShadow() {
      let frame = uiView.frame
      uiView.frame = uiView.frame.inset(by: .init(top: 5, left: 2, bottom: -3, right: 3))
      let layer = uiView.layer
      let radius = layer.shadowRadius
      let color = layer.shadowColor
      let opacity = layer.shadowOpacity
      let masksToBounds = layer.masksToBounds
      let clipsToBounds = uiView.clipsToBounds
      layer.masksToBounds = false
      uiView.clipsToBounds = false
      layer.shadowOpacity = 0.15
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowRadius = 5
      UIView.animate(withDuration: 0.3) {
         self.uiView.frame = frame
         layer.shadowOpacity = opacity
         layer.shadowColor = color
         layer.shadowRadius = 100
         self.uiView.setNeedsDisplay()
      } completion: { _ in
         layer.shadowRadius = radius
         layer.masksToBounds = masksToBounds
         self.uiView.clipsToBounds = clipsToBounds
      }
   }
}
