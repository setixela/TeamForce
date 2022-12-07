//
//  ViewModel+Setters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 14.08.2022.
//

import AlamofireImage
import Anchorage
import ReactiveWorks
import UIKit

// TODO: - сделать нормально
final class StaticAnimation {
   private(set) static var animateCount = 0
   static let animateStep: Double = 0.05

   static func increment() {
      animateCount += 1
   }

   static func decrement() {
      if animateCount > 0 {
         animateCount -= 1
      }
   }

   static var delay: Double {
      Double(animateCount - 1) * animateStep
   }
}

extension ViewModelProtocol where Self: Stateable {
   @discardableResult func backColor(_ value: UIColor) -> Self {
      view.backgroundColor = value
      return self
   }

   @discardableResult func cornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      return self
   }

   @discardableResult func borderWidth(_ value: CGFloat) -> Self {
      view.layer.borderWidth = value
      return self
   }

   @discardableResult func borderColor(_ value: UIColor) -> Self {
      view.layer.borderColor = value.cgColor
      return self
   }

   @discardableResult func size(_ value: CGSize) -> Self {
      width(value.width)
      height(value.height)
      return self
   }

   @discardableResult func height(_ value: CGFloat) -> Self {
      view.addAnchors.constHeight(value)
      return self
   }

   @discardableResult func width(_ value: CGFloat) -> Self {
      view.addAnchors.constWidth(value)
      return self
   }

   @discardableResult func maxHeight(_ value: CGFloat) -> Self {
      view.addAnchors.maxHeight(value)
      return self
   }

   @discardableResult func maxWidth(_ value: CGFloat) -> Self {
      view.addAnchors.maxWidth(value)
      return self
   }

   @discardableResult func minHeight(_ value: CGFloat) -> Self {
      view.addAnchors.minHeight(value)
      return self
   }

   @discardableResult func minWidth(_ value: CGFloat) -> Self {
      view.addAnchors.minHeight(value)
      return self
   }

   @discardableResult func sizeAspect(_ value: CGSize) -> Self {
      widthAspect(value.width)
      heightAspect(value.height)
      return self
   }

   @discardableResult func heightAspect(_ value: CGFloat) -> Self {
      view.addAnchors.constHeight(value * Config.sizeAspectCoeficient)
      return self
   }

   @discardableResult func widthAspect(_ value: CGFloat) -> Self {
      view.addAnchors.constWidth(value * Config.sizeAspectCoeficient)
      return self
   }

   @discardableResult func hidden(_ value: Bool, isAnimated: Bool = false) -> Self {
      guard isAnimated, value != view.isHidden else {
         view.isHidden = value
         return self
      }

      let curAlpha = view.alpha
      if !value {
         view.alpha = 0
         StaticAnimation.increment()
         UIView.animate(withDuration: StaticAnimation.animateStep, delay: StaticAnimation.delay) {
            self.view.alpha = curAlpha
         } completion: { _ in
            StaticAnimation.decrement()
         }
         view.isHidden = value
      } else {
         StaticAnimation.increment()
         UIView.animate(withDuration: StaticAnimation.animateStep, delay: StaticAnimation.delay) {
            self.view.alpha = 0
         } completion: { _ in
            self.view.alpha = curAlpha
            self.view.isHidden = value
            StaticAnimation.decrement()
            self.view.isHidden = value
         }
      }
      return self
   }

   @discardableResult func hiddenAnimated(_ isHidden: Bool, duration: CGFloat) -> Self {
      if isHidden == false {
         view.isHidden = false
      }
      UIView.animate(withDuration: duration) {
         self.view.alpha = isHidden ? 0 : 1
      } completion: { _ in
         self.view.isHidden = isHidden
      }

      return self
   }

   @discardableResult func alpha(_ value: CGFloat) -> Self {
      view.alpha = value
      return self
   }

   @discardableResult func zPosition(_ value: CGFloat) -> Self {
      view.layer.masksToBounds = false
      view.clipsToBounds = false
      view.layer.zPosition = value
      view.setNeedsLayout()
      return self
   }

   @discardableResult func placing(_ value: CGPoint) -> Self {
      view.center = value
      return self
   }

   @discardableResult func shadow(_ value: Shadow) -> Self {
      view.layer.shadowColor = value.color.cgColor
      view.layer.shadowOffset = .init(width: value.offset.x, height: value.offset.y)
      view.layer.shadowRadius = value.radius
      view.layer.shadowOpacity = Float(value.opacity)
      return self
   }

   @discardableResult func shadowOpacity(_ value: CGFloat) -> Self {
      view.layer.shadowOpacity = Float(value)
      return self
   }

   @discardableResult func addModel(_ value: UIViewModel, setup: (Anchors, UIView) -> Void) -> Self {
      let subview = value.uiView
      view.addSubview(subview)
      setup(subview.addAnchors, view)
      return self
   }

   @discardableResult func subviewModel(_ value: UIViewModel) -> Self {
      let subview = value.uiView
      view.addSubview(subview)
      subview.addAnchors.fitToView(view)

      return self
   }

   @discardableResult func subviewModels(_ value: [UIViewModel]) -> Self {
      value.forEach {
         let subview = $0.uiView
         view.addSubview(subview)
         subview.addAnchors.fitToView(view)
      }
      return self
   }

   @discardableResult func contentMode(_ value: UIView.ContentMode) -> Self {
      view.contentMode = value
      return self
   }

   @discardableResult func safeAreaOffsetDisabled() -> Self {
      view.insetsLayoutMarginsFromSafeArea = false
      return self
   }

   @discardableResult func clipsToBound(_ value: Bool) -> Self {
      view.clipsToBounds = value
      return self
   }

   @discardableResult func removeAllConstraints() -> Self {
      view.removeAllConstraints()
      return self
   }

   @discardableResult func userInterractionEnabled(_ value: Bool) -> Self {
      view.isUserInteractionEnabled = value
      return self
   }

   @discardableResult func contentScale(_ value: CGFloat) -> Self {
      view.contentScaleFactor = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: StackViewExtended {
   @discardableResult func distribution(_ value: StackViewExtended.Distribution) -> Self {
      view.distribution = value
      return self
   }

   @discardableResult func axis(_ value: NSLayoutConstraint.Axis) -> Self {
      view.axis = value
      return self
   }

   @discardableResult func spacing(_ value: CGFloat) -> Self {
      view.spacing = value
      return self
   }

   @discardableResult func alignment(_ value: StackViewExtended.Alignment) -> Self {
      view.alignment = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.layoutMargins = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func padLeft(_ value: CGFloat) -> Self {
      view.layoutMargins.left = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func padRight(_ value: CGFloat) -> Self {
      view.layoutMargins.right = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func padTop(_ value: CGFloat) -> Self {
      view.layoutMargins.top = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func padBottom(_ value: CGFloat) -> Self {
      view.layoutMargins.bottom = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func arrangedModels(_ value: [UIViewModel]) -> Self {
      view.arrangedSubviews.forEach {
         $0.removeFromSuperview()
      }
      value.forEach {
         let subview = $0.uiView
         view.addArrangedSubview(subview)
      }
      return self
   }

   @discardableResult func arrangedModels(_ value: UIViewModel...) -> Self {
      arrangedModels(value)
   }

   @discardableResult func addArrangedModel(_ value: UIViewModel) -> Self {
      let subview = value.uiView
      view.addArrangedSubview(subview)

      return self
   }

   @discardableResult func addArrangedModels(_ value: [UIViewModel]) -> Self {
      value.forEach {
         let subview = $0.uiView
         view.addArrangedSubview(subview)
      }
      return self
   }

   @discardableResult func removeLastModel() -> Self {
      view.arrangedSubviews.last?.removeFromSuperview()
      return self
   }

   @discardableResult func backView(_ value: UIView, inset: UIEdgeInsets = .zero) -> Self {
      view.insertSubview(value, at: 0)
      view.backView = value
      value.addAnchors.fitToViewInsetted(view, inset)
      value.contentMode = .scaleAspectFill
      value.clipsToBounds = true
      value.layer.masksToBounds = false
      return self
   }

   @discardableResult func backImage(_ value: UIImage, contentMode: UIImageView.ContentMode = .scaleAspectFill) -> Self {
      let imageView = PaddingImageView(image: value)
      imageView.contentMode = contentMode
      backView(imageView)
      return self
   }

   @discardableResult func backViewModel(_ value: UIViewModel, inset: UIEdgeInsets = .zero) -> Self {
      let new = value.uiView
      backView(new, inset: inset)
      return self
   }

   @discardableResult func disableBottomRadius(_ value: CGFloat) -> Self {
      let backView = UIView()
      backView.backgroundColor = view.backgroundColor
      view.insertSubview(backView, at: 0)
      backView.addAnchors
         .constHeight(value)
         .width(view.widthAnchor)
         .bottom(view.bottomAnchor)
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingLabel {
   @discardableResult func text(_ value: String) -> Self {
      let current = NSMutableAttributedString(attributedString: view.attributedText ?? NSMutableAttributedString())
      current.mutableString.setString(value)
      current.addAttribute(.paragraphStyle,
                           value: view.paragraphStyle,
                           range: .init(location: 0, length: current.length))

      view.attributedText = current
      view.sizeToFit()
      return self
   }

   @discardableResult func font(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func textColor(_ value: UIColor) -> Self {
      view.textColor = value
      return self
   }

   @discardableResult func numberOfLines(_ value: Int) -> Self {
      view.numberOfLines = value
      return self
   }

   @discardableResult func alignment(_ value: NSTextAlignment) -> Self {
      view.paragraphStyle.alignment = value
      return self
   }

   @discardableResult func attributedText(_ value: NSAttributedString) -> Self {
      view.attributedText = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func padLeft(_ value: CGFloat) -> Self {
      view.padding.left = value
      return self
   }

   @discardableResult func padRight(_ value: CGFloat) -> Self {
      view.padding.right = value
      return self
   }

   @discardableResult func padTop(_ value: CGFloat) -> Self {
      view.padding.top = value
      return self
   }

   @discardableResult func padBottom(_ value: CGFloat) -> Self {
      view.padding.bottom = value
      return self
   }

   @discardableResult func cornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      view.clipsToBounds = true
      return self
   }

   @discardableResult func lineBreakMode(_ value: NSLineBreakMode) -> Self {
      view.paragraphStyle.lineBreakMode = value
      return self
   }

   @discardableResult func lineSpacing(_ value: CGFloat) -> Self {
      let style = view.paragraphStyle
      style.lineSpacing = value
      let string = view.attributedText ?? NSAttributedString()
      let attrStr = NSMutableAttributedString(attributedString: string)
      attrStr.addAttribute(.paragraphStyle, value: style, range: .init())
      view.attributedText = attrStr
      view.paragraphStyle = style
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   @discardableResult func image(_ value: UIImage, color: UIColor? = nil) -> Self {
      let image = color == nil ? value : value.withTintColor(color!)
      view.image = image
      view.layer.masksToBounds = true
      return self
   }

   @discardableResult func textImage(_ value: String, _ backColor: UIColor) -> Self {
      DispatchQueue.global(qos: .background).async { [weak self] in
         let image = value.drawImage(backColor: backColor)
         DispatchQueue.main.async {
            self?.view.image = image
            self?.view.backgroundColor = backColor
            self?.view.layer.masksToBounds = true
         }
      }
      return self
   }

   @discardableResult func contentMode(_ value: UIView.ContentMode) -> Self {
      view.contentMode = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func imageTintColor(_ value: UIColor) -> Self {
      view.image = view.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
      view.tintColor = value
      return self
   }

   @discardableResult func cornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      view.clipsToBounds = true
      view.layer.masksToBounds = true
      return self
   }

   @discardableResult func url(_ value: String?,
                               placeHolder: UIImage? = nil,
                               transition: UIImageView.ImageTransition = .noTransition,
                               closure: ((Self?, UIImage?) -> Void)? = nil) -> Self
   {
      view.layer.masksToBounds = true

      guard let url = URL(string: value ?? "") else {
         view.image = placeHolder ?? view.image
         return self
      }

      view.af.setImage(
         withURL: url,
         placeholderImage: placeHolder,
         imageTransition: transition
      ) {
         weak var slf = self

         switch $0.result {
         case .success(let image):
            closure?(slf, image)
         case .failure:
            closure?(slf, nil)
         }
      }

      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   @discardableResult func enabled(_ value: Bool) -> Self {
      view.isEnabled = value
      return self
   }

   @discardableResult func selected(_ value: Bool) -> Self {
      view.isSelected = value
      return self
   }

   @discardableResult func title(_ value: String) -> Self {
      view.setTitle(value, for: .normal)
      return self
   }

   @discardableResult func textColor(_ value: UIColor) -> Self {
      view.setTitleColor(value, for: .normal)
      return self
   }

   @discardableResult func font(_ value: UIFont) -> Self {
      view.titleLabel?.font = value
      return self
   }

   @discardableResult func image(_ value: UIImage?, color: UIColor? = nil) -> Self {
      let image = color == nil ? value : value?.withTintColor(color!)
      view.setImage(image, for: .normal)
      return self
   }

   @discardableResult func backImage(_ value: UIImage?) -> Self {
      view.setBackgroundImage(value, for: .normal)
      return self
   }

   @discardableResult func imageContentMode(_ value: UIView.ContentMode) -> Self {
      view.imageView?.contentMode = value
      return self
   }

   @discardableResult func tint(_ value: UIColor) -> Self {
      view.tintColor = value
      view.setTitleColor(value, for: .normal)
      view.imageView?.tintColor = value
      return self
   }

   @discardableResult func vertical(_ value: Bool) -> Self {
      view.isVertical = value
      return self
   }

   @discardableResult func imageInset(_ value: UIEdgeInsets) -> Self {
      view.imageEdgeInsets = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.contentEdgeInsets = value
      return self
   }

   @discardableResult func backImageUrl(_ value: String?) -> Self {
      view.loadImage(value) { [weak view] in
         guard let image = $0 else { return }

         view?.setBackgroundImage(image, for: .normal)
      }

      return self
   }

   @discardableResult func cornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      view.clipsToBounds = true
      return self
   }

   @discardableResult func shadow(_ value: Shadow) -> Self {
      view.layer.shadowColor = value.color.cgColor
      view.layer.shadowOffset = .init(width: value.offset.x, height: value.offset.y)
      view.layer.shadowRadius = value.radius
      view.layer.shadowOpacity = Float(value.opacity)
      view.clipsToBounds = false
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   @discardableResult func text(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func placeholder(_ value: String) -> Self {
      view.placeholder = value
      return self
   }

   @discardableResult func placeholderColor(_ value: UIColor) -> Self {
      let placeholder = view.placeholder.string
      view.attributedPlaceholder = NSAttributedString(
         string: placeholder,
         attributes: [NSAttributedString.Key.foregroundColor: value]
      )
      return self
   }

   @discardableResult func font(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
      view.clearButtonMode = value
      return self
   }

   @discardableResult func alignment(_ value: NSTextAlignment) -> Self {
      view.textAlignment = value
      return self
   }

   @discardableResult func textColor(_ value: UIColor) -> Self {
      view.textColor = value
      return self
   }

   @discardableResult func keyboardType(_ value: UIKeyboardType) -> Self {
      view.keyboardType = value
      return self
   }

   @discardableResult func onlyDigitsMode() -> Self {
      view.isOnlyDigitsMode = true
      return self
   }

   @discardableResult func disableAutocorrection() -> Self {
      view.autocorrectionType = .no
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: TextViewExtended {
   @discardableResult func text(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func placeholder(_ value: String) -> Self {
      view.placeholder = value
      view.textViewDidEndEditing(view)
      return self
   }

   @discardableResult func placeholderColor(_ value: UIColor) -> Self {
      view.placeHolderColor = value
      view.textViewDidEndEditing(view)
      return self
   }

   @discardableResult func font(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func padding(_ value: UIEdgeInsets) -> Self {
      view.textContainerInset = value
      return self
   }

   @discardableResult func alignment(_ value: NSTextAlignment) -> Self {
      view.textAlignment = value
      return self
   }

   @discardableResult func textColor(_ value: UIColor) -> Self {
      view.baseTextColor = value
      return self
   }

   @discardableResult func keyboardType(_ value: UIKeyboardType) -> Self {
      view.keyboardType = value
      return self
   }

   @discardableResult func disableAutocorrection() -> Self {
      view.autocorrectionType = .no
      return self
   }
}
