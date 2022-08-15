//
//  ViewModel+Setters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 14.08.2022.
//

import ReactiveWorks
import UIKit

extension ViewModelProtocol where Self: Stateable {
   @discardableResult func set_backColor(_ value: UIColor) -> Self {
      view.backgroundColor = value
      return self
   }

   @discardableResult func set_cornerRadius(_ value: CGFloat) -> Self {
      view.layer.cornerRadius = value
      return self
   }

   @discardableResult func set_borderWidth(_ value: CGFloat) -> Self {
      view.layer.borderWidth = value
      return self
   }

   @discardableResult func set_borderColor(_ value: UIColor) -> Self {
      view.layer.borderColor = value.cgColor
      return self
   }

   @discardableResult func set_size(_ value: CGSize) -> Self {
      view.addAnchors
         .constWidth(value.width)
         .constHeight(value.height)
      return self
   }

   @discardableResult func set_height(_ value: CGFloat) -> Self {
      view.addAnchors.constHeight(value)
      return self
   }

   @discardableResult func set_width(_ value: CGFloat) -> Self {
      view.addAnchors.constWidth(value)
      return self
   }

   @discardableResult func set_hidden(_ value: Bool) -> Self {
      view.isHidden = value
      return self
   }

   @discardableResult func set_zPosition(_ value: CGFloat) -> Self {
      view.layer.masksToBounds = false
      view.layer.zPosition = value
      view.setNeedsLayout()
      return self
   }

   @discardableResult func set_placing(_ value: CGPoint) -> Self {
      view.center = value
      return self
   }

   @discardableResult func set_shadow(_ value: Shadow) -> Self {
      view.layer.shadowColor = value.color.cgColor
      view.layer.shadowOffset = .init(width: value.offset.x, height: value.offset.y)
      view.layer.shadowRadius = value.radius
      view.layer.shadowOpacity = Float(value.opacity)
      return self
   }
}


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
}

extension ViewModelProtocol where Self: Stateable, View: UIStackView {
   @discardableResult func set_distribution(_ value: UIStackView.Distribution) -> Self {
      view.distribution = value
      return self
   }

   @discardableResult func set_axis(_ value: NSLayoutConstraint.Axis) -> Self {
      view.axis = value
      return self
   }

   @discardableResult func set_spacing(_ value: CGFloat) -> Self {
      view.spacing = value
      return self
   }

   @discardableResult func set_alignment(_ value: UIStackView.Alignment) -> Self {
      view.alignment = value
      return self
   }

   @discardableResult func set_padding(_ value: UIEdgeInsets) -> Self {
      view.layoutMargins = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func set_padLeft(_ value: CGFloat) -> Self {
      view.layoutMargins.left = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func set_padRight(_ value: CGFloat) -> Self {
      view.layoutMargins.right = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func set_padTop(_ value: CGFloat) -> Self {
      view.layoutMargins.top = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func set_padBottom(_ value: CGFloat) -> Self {
      view.layoutMargins.bottom = value
      view.isLayoutMarginsRelativeArrangement = true
      return self
   }

   @discardableResult func set_models(_ value: [UIViewModel]) -> Self {
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

   @discardableResult func set_backImage(_ value: UIImage, contentMode: UIImageView.ContentMode = .scaleAspectFill) -> Self {
      let imageView = PaddingImageView(image: value)
      imageView.contentMode = contentMode
      setBackView(imageView)
      return self
   }

   @discardableResult func set_backViewModel(_ value: UIViewModel, inset: UIEdgeInsets = .zero) -> Self {
      let backView = value.uiView
      view.insertSubview(backView, at: 0)
      backView.addAnchors.fitToViewInsetted(view, inset)
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingLabel {
   @discardableResult func set_text(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func set_font(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func set_color(_ value: UIColor) -> Self {
      view.textColor = value
      return self
   }

   @discardableResult func set_numberOfLines(_ value: Int) -> Self {
      view.numberOfLines = value
      return self
   }

   @discardableResult func set_alignment(_ value: NSTextAlignment) -> Self {
      view.textAlignment = value
      return self
   }

   @discardableResult func set_padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func set_padLeft(_ value: CGFloat) -> Self {
      view.padding.left = value
      return self
   }

   @discardableResult func set_padRight(_ value: CGFloat) -> Self {
      view.padding.right = value
      return self
   }

   @discardableResult func set_padTop(_ value: CGFloat) -> Self {
      view.padding.top = value
      return self
   }

   @discardableResult func set_padBottom(_ value: CGFloat) -> Self {
      view.padding.bottom = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   @discardableResult func set_image(_ value: UIImage) -> Self {
      view.image = value
      return self
   }

   @discardableResult func set_contentMode(_ value: UIView.ContentMode) -> Self {
      view.contentMode = value
      return self
   }

   @discardableResult func set_padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func set_tintColor(_ value: UIColor) -> Self {
      view.image = view.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
      view.tintColor = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   @discardableResult func set_enabled(_ value: Bool) -> Self {
      view.isEnabled = value
      return self
   }

   @discardableResult func set_selected(_ value: Bool) -> Self {
      view.isSelected = value
      return self
   }

   @discardableResult func set_title(_ value: String) -> Self {
      view.setTitle(value, for: .normal)
      return self
   }

   @discardableResult func set_textColor(_ value: UIColor) -> Self {
      view.setTitleColor(value, for: .normal)
      return self
   }

   @discardableResult func set_font(_ value: UIFont) -> Self {
      view.titleLabel?.font = value
      return self
   }

   @discardableResult func set_image(_ value: UIImage) -> Self {
      view.setImage(value, for: .normal)
      return self
   }

   @discardableResult func set_tint(_ value: UIColor) -> Self {
      view.tintColor = value
      view.imageView?.tintColor = value
      return self
   }

   @discardableResult func set_vertical(_ value: Bool) -> Self {
      view.isVertical = value
      return self
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   @discardableResult func set_text(_ value: String) -> Self {
      view.text = value
      return self
   }

   @discardableResult func set_placeholder(_ value: String) -> Self {
      view.placeholder = value
      return self
   }

   @discardableResult func set_font(_ value: UIFont) -> Self {
      view.font = value
      return self
   }

   @discardableResult func set_padding(_ value: UIEdgeInsets) -> Self {
      view.padding = value
      return self
   }

   @discardableResult func set_clearButtonMode(_ value: UITextField.ViewMode) -> Self {
      view.clearButtonMode = value
      return self
   }
}