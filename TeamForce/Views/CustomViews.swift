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
   var events: EventsStore = .init() {
      didSet {
         // startTapGestureRecognize()
         // print("started events")
      }
   }

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

      textWidth += insetsWidth

      let newSize = text.boundingRect(with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
                                      options: [.usesLineFragmentOrigin],
                                      attributes: [NSAttributedString.Key.font: font!],
                                      context: nil)

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
         let str = urlStr,
         let url = URL(string: str)
      else { result(nil); return }

      AF.request(str).responseImage {
         if case .success(let image) = $0.result {
            result(image)
            return
         }
         result(nil)
      }

//      let imageDownloader = ImageDownloader(
//         configuration: ImageDownloader.defaultURLSessionConfiguration(),
//         downloadPrioritization: .lifo,
//         maximumActiveDownloads: 4,
//         imageCache: AutoPurgingImageCache(memoryCapacity: 500_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
//      )
//
//      let urlRequest = URLRequest(url: url)
//
//      imageDownloader.download(urlRequest, completion: { response in
//
//         guard case .success(let image) = response.result else { result(nil); return }
//
//         let coef = image.size.width / image.size.height
//         let image2 = image.resized(to: .init(width: 256, height: 256 / coef))
//         result(image2)
//      })
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

   override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      if !clipsToBounds, !isHidden, alpha > 0 {
         let button = subviews.flatMap {
            $0.subviews.flatMap(\.subviews)
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
