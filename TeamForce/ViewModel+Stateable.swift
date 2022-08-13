//
//  ViewModel+Stateable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.07.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

enum ViewState {
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case size(CGSize)
   case height(CGFloat)
   case width(CGFloat)
   case hidden(Bool)
   case zPosition(CGFloat)
   case placing(CGPoint)
}

// MARK: -  Stateable extensions

extension ViewModelProtocol where Self: Stateable {
   func applyState(_ state: ViewState) {
      switch state {
      case .backColor(let value):
         view.backgroundColor = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .cornerRadius(let value):
         view.layer.cornerRadius = value
      case .borderColor(let value):
         view.layer.borderColor = value.cgColor
      case .borderWidth(let value):
         view.layer.borderWidth = value
      case .hidden(let value):
         view.isHidden = value
      case .size(let size):
         view.addAnchors
            .constWidth(size.width)
            .constHeight(size.height)
      case .zPosition(let value):
         view.layer.masksToBounds = false
         view.layer.zPosition = value
         view.setNeedsLayout()
      case .placing(let value):
         view.center = value
      case .width(let value):
         view.addAnchors.constWidth(value)
      }
   }
}

enum StackState {
   case distribution(UIStackView.Distribution)
   case axis(NSLayoutConstraint.Axis)
   case spacing(CGFloat)
   case alignment(UIStackView.Alignment)
   case padding(UIEdgeInsets)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case height(CGFloat)
   case models([UIViewModel])
   case hidden(Bool)
   case backView(UIView, inset: UIEdgeInsets = .zero)
   case backImage(UIImage)
}

// MARK: -  Stateable extensions

extension ViewModelProtocol where Self: Stateable, View: UIStackView {
   func applyState(_ state: StackState) {
      switch state {
      case .distribution(let value):
         view.distribution = value
      case .axis(let value):
         view.axis = value
      case .spacing(let value):
         view.spacing = value
      case .alignment(let value):
         view.alignment = value
      case .padding(let value):
         view.layoutMargins = value
         view.isLayoutMarginsRelativeArrangement = true
      case .backColor(let value):
         view.backgroundColor = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .models(let models):
         view.subviews.forEach {
            $0.removeFromSuperview()
         }
         models.forEach {
            let subview = $0.uiView
            print(subview)
            view.addArrangedSubview($0.uiView)
         }
      case .cornerRadius(let value):
         view.layer.cornerRadius = value
      case .borderColor(let value):
         view.layer.borderColor = value.cgColor
      case .borderWidth(let value):
         view.layer.borderWidth = value
      case .hidden(let value):
         view.isHidden = value
      case .backView(let backView, let inset):
         view.insertSubview(backView, at: 0)
         backView.addAnchors.fitToViewInsetted(view, inset)
      case .backImage(let image):
         applyState(.backView(PaddingImageView(image: image)))
      }
   }
}

enum LabelState {
   case text(String)
   case font(UIFont)
   case color(UIColor)
   case numberOfLines(Int)
   case alignment(NSTextAlignment)
   // Padding
   case padding(UIEdgeInsets)
   case padLeft(CGFloat)
   case padRight(CGFloat)
   case padUp(CGFloat)
   case padBottom(CGFloat)
}

extension ViewModelProtocol where Self: Stateable, View: PaddingLabel {
   func applyState(_ state: LabelState) {
      switch state {
      case .text(let value):
         view.text = value
      case .font(let value):
         view.font = value
      case .color(let value):
         view.textColor = value
      case .numberOfLines(let value):
         view.numberOfLines = value
      case .alignment(let value):
         view.textAlignment = value
      case .padding(let value):
         view.padding = value
      case .padLeft(let value):
         view.padding.left = value
      case .padRight(let value):
         view.padding.right = value
      case .padUp(let value):
         view.padding.top = value
      case .padBottom(let value):
         view.padding.bottom = value
      }
   }
}

enum ImageViewState {
   case image(UIImage)
   case contentMode(UIView.ContentMode)
   case padding(UIEdgeInsets)
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   func applyState(_ state: ImageViewState) {
      switch state {
      case .image(let uIImage):
         view.image = uIImage
      case .contentMode(let mode):
         view.contentMode = mode
      case .padding(let value):
         view.padding = value
      }
   }
}

extension UIEdgeInsets {
   static func left(_ offset: CGFloat) -> UIEdgeInsets {
      UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
   }
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   func applyState(_ state: ButtonState) {
      switch state {
      case .enabled(let value):
         view.isEnabled = value
      case .selected(let value):
         view.isSelected = value
      case .title(let title):
         view.setTitle(title, for: .normal)
      case .textColor(let color):
         view.setTitleColor(color, for: .normal)
      case .backColor(let color):
         view.backgroundColor = color
      case .cornerRadius(let radius):
         view.layer.cornerRadius = radius
      case .height(let height):
         view.addAnchors.constHeight(height)
      case .font(let font):
         view.titleLabel?.font = font
      case .image(let image):
         view.setImage(image, for: .normal)
      case .tint(let value):
         view.tintColor = value
         view.imageView?.tintColor = value
      case .vertical(let value):
         view.isVertical = value
      case .hidden(let value):
         view.isHidden = value
      }
   }
}

// MARK: - TextFieldModel

enum TextFieldState {
   case text(String)
   case placeholder(String)
   case backColor(UIColor)
   case font(UIFont)
   case clearButtonMode(UITextField.ViewMode)
   case padding(UIEdgeInsets)
   case height(CGFloat)
   case widht(CGFloat)

   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case size(CGSize)
   case hidden(Bool)
   case zPosition(CGFloat)
   case placing(CGPoint)
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   func applyState(_ state: TextFieldState) {
      switch state {
      case .text(let string):
         view.text = string
      case .placeholder(let string):
         view.placeholder = string
      case .backColor(let value):
         view.backgroundColor = value
      case .font(let font):
         view.font = font
      case .clearButtonMode(let value):
         view.clearButtonMode = value
      case .padding(let value):
         view.padding = value
      case .height(let value):
         view.addAnchors.constHeight(value)
      case .widht(let value):
         view.addAnchors.constWidth(value)

      case .cornerRadius(let value):
         view.layer.cornerRadius = value
      case .borderColor(let value):
         view.layer.borderColor = value.cgColor
      case .borderWidth(let value):
         view.layer.borderWidth = value
      case .hidden(let value):
         view.isHidden = value
      case .size(let size):
         view.addAnchors
            .constWidth(size.width)
            .constHeight(size.height)
      case .zPosition(let value):
         view.layer.masksToBounds = false
         view.layer.zPosition = value
         view.setNeedsLayout()
      case .placing(let value):
         view.center = value
      }
   }
}
