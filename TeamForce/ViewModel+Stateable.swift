//
//  ViewModel+Stateable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.07.2022.
//

import UIKit
import ReactiveWorks
import Anchorage

enum ViewState {
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case size(CGSize)
   case height(CGFloat)
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
         applyState(.backView(UIImageView(image: image)))
      }
   }
}

enum LabelState {
   case text(String)
   case font(UIFont)
   case color(UIColor)
   case numberOfLines(Int)
   case alignment(NSTextAlignment)
   case padding(UIEdgeInsets)
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
      }
   }
}
