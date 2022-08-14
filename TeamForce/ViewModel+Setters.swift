//
//  ViewModel+Setters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 14.08.2022.
//

import ReactiveWorks
import UIKit

extension ViewModelProtocol where Self: Stateable {
   @discardableResult func setBackColor(_ value: UIColor) -> Self {
      view.backgroundColor = value
      return self
   }

   @discardableResult func setCornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      return self
   }

   @discardableResult func setBorderWidth(_ value: CGFloat) -> Self {
      view.layer.borderWidth = value
      return self
   }

   @discardableResult func setBorderColor(_ value: UIColor) -> Self {
      view.layer.borderColor = value.cgColor
      return self
   }

   @discardableResult func setSize(_ value: CGSize) -> Self {
      view.addAnchors
         .constWidth(value.width)
         .constHeight(value.height)
      return self
   }

   @discardableResult func setHeight(_ value: CGFloat) -> Self {
      view.addAnchors.constHeight(value)
      return self
   }

   @discardableResult func setWidth(_ value: CGFloat) -> Self {
      view.addAnchors.constWidth(value)
      return self
   }

   @discardableResult func setHidden(_ value: Bool) -> Self {
      view.isHidden = value
      return self
   }

   @discardableResult func setZPosition(_ value: CGFloat) -> Self {
      view.layer.masksToBounds = false
      view.layer.zPosition = value
      view.setNeedsLayout()
      return self
   }

   @discardableResult func setPlacing(_ value: CGPoint) -> Self {
      view.center = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: UIStackView {
   @discardableResult func setDistribution(_ value: UIStackView.Distribution) -> Self {
      view.distribution = value
      return self
   }

   @discardableResult func setAxis(_ value: NSLayoutConstraint.Axis) -> Self {
      view.axis = value
      return self
   }

   @discardableResult func setSpacing(_ value: CGFloat) -> Self {
      view.spacing = value
      return self
   }

   @discardableResult func setAlignment(_ value: UIStackView.Alignment) -> Self {
      view.alignment = value
      return self
   }

   @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
      view.layoutMargins = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func setModels(_ value: [UIViewModel]) -> Self {
      view.subviews.forEach {
         $0.removeFromSuperview()
      }
      value.forEach {
         let subview = $0.uiView
         print(subview)
         view.addArrangedSubview($0.uiView)
      }
      return self
   }

   @discardableResult func setBackView(_ value: UIView, inset: UIEdgeInsets = .zero) -> Self {
      view.insertSubview(value, at: 0)
      value.addAnchors.fitToViewInsetted(view, inset)
      return self
   }

   @discardableResult func setBackImage(_ value: UIImage) -> Self {
      applyState(.backView(PaddingImageView(image: value)))
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingLabel {
   @discardableResult func setText(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func setFont(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func setColor(_ value: UIColor) -> Self {
      view.textColor = value
      return self
   }

   @discardableResult func setNumberOfLines(_ value: Int) -> Self {
      view.numberOfLines = value
      return self
   }

   @discardableResult func setAlignment(_ value: NSTextAlignment) -> Self {
      view.textAlignment = value
      return self
   }

   @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func setPadLeft(_ value: CGFloat) -> Self {
      view.padding.left = value
      return self
   }

   @discardableResult func setPadRight(_ value: CGFloat) -> Self {
      view.padding.right = value
      return self
   }

   @discardableResult func setPadTop(_ value: CGFloat) -> Self {
      view.padding.top = value
      return self
   }

   @discardableResult func setPadBottom(_ value: CGFloat) -> Self {
      view.padding.bottom = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   @discardableResult func setImage(_ value: UIImage) -> Self {
      view.image = value
      return self
   }

   @discardableResult func setContentMode(_ value: UIView.ContentMode) -> Self {
      view.contentMode = value
      return self
   }

   @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   @discardableResult func setEnabled(_ value: Bool) -> Self {
      view.isEnabled = value
      return self
   }

   @discardableResult func setSelected(_ value: Bool) -> Self {
      view.isSelected = value
      return self
   }

   @discardableResult func setTitle(_ value: String) -> Self {
      view.setTitle(value, for: .normal)
      return self
   }

   @discardableResult func setTextColor(_ value: UIColor) -> Self {
      view.setTitleColor(value, for: .normal)
      return self
   }

   @discardableResult func setFont(_ value: UIFont) -> Self {
      view.titleLabel?.font = value
      return self
   }

   @discardableResult func setImage(_ value: UIImage) -> Self {
      view.setImage(value, for: .normal)
      return self
   }

   @discardableResult func setTint(_ value: UIColor) -> Self {
      view.tintColor = value
      view.imageView?.tintColor = value
      return self
   }

   @discardableResult func setVertical(_ value: Bool) -> Self {
      view.isVertical = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   @discardableResult func setText(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func setPlaceholder(_ value: String) -> Self {
      view.placeholder = value
      return self
   }

   @discardableResult func setFont(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func setClearButtonMode(_ value: UITextField.ViewMode) -> Self {
      view.clearButtonMode = value
      return self
   }
}
