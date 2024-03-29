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

protocol Tappable: Eventable where Events == ButtonEvents {}

@objc protocol TappableView {
   func startTapGestureRecognize(cancelTouch: Bool)
   @objc func didTap()
}

extension UIView: TappableView {
   func startTapGestureRecognize(cancelTouch: Bool = false) {
      let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
      gesture.cancelsTouchesInView = cancelTouch
      addGestureRecognizer(gesture)
      isUserInteractionEnabled = true
   }

   @objc func didTap() {
      (self as? any Tappable)?.send(\.didTap)
      animateTap(uiView: self)
   }
}

extension UIView: ButtonTapAnimator {}

// MARK: - PaddingLabel -------------------------

final class PaddingLabel: UILabel, Marginable, Tappable {
   var events: EventsStore = .init()

   var padding: UIEdgeInsets = .init()

   lazy var paragraphStyle: NSMutableParagraphStyle = .init()

   override public func draw(_ rect: CGRect) {
      drawText(in: rect.inset(by: padding))
   }

   override var intrinsicContentSize: CGSize {
      guard let text, let font else { return super.intrinsicContentSize }

      var contentSize = super.intrinsicContentSize
      var textWidth: CGFloat = contentSize.width
      var insetsHeight: CGFloat = 0.0
      var insetsWidth: CGFloat = 0.0

      insetsWidth += padding.left + padding.right
      insetsHeight += padding.top + padding.bottom

      textWidth += insetsWidth

      let maxHeight =
         font.lineHeight * (numberOfLines == 0 ? CGFloat.greatestFiniteMagnitude : CGFloat(numberOfLines + 1))

      var newSize: CGRect
      if let attributedText, !attributedText.string.isEmpty,
         let kern = attributedText.attribute(.kern, at: 0, effectiveRange: nil) {
         newSize = text.boundingRect(
            with: CGSize(width: textWidth, height: maxHeight),
            options: [.usesLineFragmentOrigin],
            attributes: [NSAttributedString.Key.font: font,
                         .kern: kern,
                         .paragraphStyle: paragraphStyle],
            context: nil
         )
      } else {
         newSize = text.boundingRect(
            with: CGSize(width: textWidth, height: maxHeight),
            options: [.usesLineFragmentOrigin],
            attributes: [NSAttributedString.Key.font: font,
                         .paragraphStyle: paragraphStyle],
            context: nil
         )
      }

      contentSize.height = ceil(newSize.size.height) + insetsHeight
      contentSize.width = ceil(newSize.size.width) + insetsWidth

      return contentSize
   }

   func makePartsClickable(user1: String?, user2: String?) {
      isUserInteractionEnabled = true
      let tapGesture = CustomTap(target: self,
                                 action: #selector(tappedOnLabel(gesture:)))
      tapGesture.user1 = user1
      tapGesture.user2 = user2
      addGestureRecognizer(tapGesture)
      lineBreakMode = .byWordWrapping
   }

   @objc func tappedOnLabel(gesture: CustomTap) {
      guard let text = text else { return }

      let firstRange = (text as NSString).range(of: gesture.user1.string)
      let secondRange = (text as NSString).range(of: gesture.user2.string)
      print("first range \(firstRange)")
      print("second range \(secondRange)")
      if gesture.didTapAttributedTextInLabel(label: self, inRange: firstRange) {
         print("firstRange tapped")
         send(\.didSelect, gesture.user1.string)
      } else if gesture.didTapAttributedTextInLabel(label: self, inRange: secondRange) {
         print("secondRange tapped")
         send(\.didSelect, gesture.user2.string)
      }
   }
}

// MARK: - PaddingTextField -------------------------

/// Description
final class PaddingTextField: UITextField, Marginable {
   // padding extension
   var padding: UIEdgeInsets = .init()

   var isOnlyDigitsMode = false

   override func textRect(forBounds bounds: CGRect) -> CGRect {
      bounds.inset(by: padding)
   }

   override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      bounds.inset(by: padding)
   }

   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      bounds.inset(by: padding)
   }
}

// MARK: - PaddingImageView -------------------------

import Alamofire
import AlamofireImage

protocol AlamoLoader {}

extension AlamoLoader {
   func loadImage(_ urlStr: String?, result: @escaping (UIImage?) -> Void) {
      guard
         let str = urlStr
      else { result(nil); return }

      AF.request(str).responseImage {
         if case .success(let image) = $0.result {
            result(image)
            return
         }
         result(nil)
      }
   }
}

final class PaddingImageView: UIImageView, Marginable, AlamoLoader, Tappable {
   var padding: UIEdgeInsets = .init()

   var events: EventsStore = .init() {
      didSet {
         startTapGestureRecognize()
      }
   }

   override var alignmentRectInsets: UIEdgeInsets {
      .init(top: -padding.top,
            left: -padding.left,
            bottom: -padding.bottom,
            right: -padding.right)
   }
}

extension PaddingImageView: Eventable {
   typealias Events = ButtonEvents
}

// MARK: - PaddingView -------------------------

final class PaddingView: UIView, Marginable {
   var padding: UIEdgeInsets = .init()

   override var alignmentRectInsets: UIEdgeInsets {
      .init(top: -padding.top,
            left: -padding.left,
            bottom: -padding.bottom,
            right: -padding.right)
   }
}

// MARK: - StackViewExtendeed -------------------------

final class StackViewExtended: UIStackView, Eventable {
   struct Events: InitProtocol {
      var willAppear: Void?
      var didAppear: Void?
      var willDisappear: Void?
      var didTap: Void?
   }

   private var isGestured = false

   var events: EventsStore = .init()

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

   override func startTapGestureRecognize(cancelTouch: Bool = false) {
      let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
      gesture.cancelsTouchesInView = cancelTouch
      addGestureRecognizer(gesture)
      isUserInteractionEnabled = true
   }

   @objc override func didTap() {
      send(\.didTap)
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
         send(\.willDisappear)
      } else {
         send(\.willAppear)
      }
   }

   override func didMoveToSuperview() {
      super.didMoveToSuperview()

      send(\.didAppear)
   }

   override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      if !clipsToBounds, !isHidden, alpha > 0 {
         let button = subviews.flatMap {
            $0.subviews.flatMap(\.subviews)
         }
         .filter {
            $0 is (any Tappable)
         }
         .last(where: {
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

final class ButtonExtended: UIButton, AlamoLoader, Shimmering, Tappable {
   typealias Events = ButtonEvents

   var events: EventsStore = .init()

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

//   override func startTapGestureRecognize(cancelTouch: Bool = false) {
//      self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
//   }

   @objc override func didTap() {
      send(\.didTap)
   }

   override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
      super.setBackgroundImage(image, for: state)

      let first = subviews.first
      first?.contentMode = .scaleAspectFill
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

protocol ButtonTapAnimator {}

extension ButtonTapAnimator {
   func animateTap(uiView: UIView) {
      let frame = uiView.frame
      uiView.frame = uiView.frame.inset(by: .init(top: 3, left: 2, bottom: -2, right: 3))
      UIView.animate(withDuration: 0.3) {
         uiView.frame = frame
      }
   }

   func animateTapWithShadow(uiView: UIView) {
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
         uiView.frame = frame
         layer.shadowOpacity = opacity
         layer.shadowColor = color
         layer.shadowRadius = 100
         uiView.setNeedsDisplay()
      } completion: { _ in
         layer.shadowRadius = radius
         layer.masksToBounds = masksToBounds
         uiView.clipsToBounds = clipsToBounds
      }
   }
}

extension UIImage {
   func withInset(_ insets: UIEdgeInsets) -> UIImage {
      let cgSize = CGSize(width: size.width + insets.left * scale + insets.right * scale,
                          height: size.height + insets.top * scale + insets.bottom * scale)

      UIGraphicsBeginImageContextWithOptions(cgSize, false, scale)
      defer { UIGraphicsEndImageContext() }

      let origin = CGPoint(x: insets.left * scale, y: insets.top * scale)
      draw(at: origin)

      return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderingMode) ?? self
   }
}

protocol Shimmering: UIView {
   func draw(_ rect: CGRect)
}

extension Shimmering {
   private static var colors: [UIColor] { [.black, .white] }

   func drawGradient(_ rect: CGRect) {
      //      let context = UIGraphicsGetCurrentContext()!
      //      context.saveGState()
      //      let colors = Self.colors.map(\.cgColor)
      //
      //      let colorSpace = CGColorSpaceCreateDeviceRGB()
      //
      //      let colorLocations: [CGFloat] = [0.0, 1.0]
      //
      //      let gradient = CGGradient(colorsSpace: colorSpace,
      //                                colors: colors as CFArray,
      //                                locations: colorLocations)!
      //
      //      let startPoint = CGPoint(x: 0, y: bounds.height / 2)
      //      let endPoint = CGPoint(x: bounds.width, y: bounds.height / 2)
      //      let roundRect = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
      //      roundRect.addClip()
      //      context.drawLinearGradient(gradient,
      //                                 start: startPoint,
      //                                 end: endPoint,
      //                                 options: [.drawsAfterEndLocation])
      //      context.restoreGState()
   }

   private func animateShimmering() {}
}

// MARK: - ScrollView

final class ScrollViewExtended: UIScrollView {
   override init(frame: CGRect) {
      super.init(frame: frame)
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

final class TextViewExtended: UITextView, UITextViewDelegate {
   var events: EventsStore = .init()

   var placeholder: String? {
      didSet {
         text = placeholder
      }
   }

   var placeHolderColor: UIColor = .gray
   var baseTextColor: UIColor?

   private var isPlaceholded: Bool { text == placeholder }

   override init(frame: CGRect, textContainer: NSTextContainer?) {
      super.init(frame: frame, textContainer: textContainer)

      self.delegate = self
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   func textViewDidChange(_ textView: UITextView) {
      send(\.didEditingChanged, textView.text)
   }

   override func layoutSubviews() {
      super.layoutSubviews()

      if isPlaceholded {
         textColor = placeHolderColor
      } else {
         textColor = baseTextColor
      }
   }

   func textViewDidBeginEditing(_ textView: UITextView) {
      if isPlaceholded {
         textColor = baseTextColor
         text = ""
      }
   }

   func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == nil || textView.text.isEmpty {
         textView.text = placeholder
         textView.textColor = placeHolderColor
      }
   }
}

extension TextViewExtended: Eventable {
   typealias Events = TextViewEvents
}

// MARK: - TableViewExtended

final class TableViewExtended: UITableView {
   override var contentSize: CGSize {
      didSet {
         invalidateIntrinsicContentSize()
      }
   }

   override var intrinsicContentSize: CGSize {
      layoutIfNeeded()
      return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
   }
}
