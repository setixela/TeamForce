//
//  ViewModel+Stateable.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.07.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

// MARK: - View states

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
         setBackColor(value)
      case .height(let value):
         setHeight(value)
      case .cornerRadius(let value):
         setCornerRadius(value)
      case .borderColor(let value):
         setBorderColor(value)
      case .borderWidth(let value):
         setBorderWidth(value)
      case .hidden(let value):
         setHidden(value)
      case .size(let value):
         setSize(value)
      case .zPosition(let value):
         setZPosition(value)
      case .placing(let value):
         setPlacing(value)
      case .width(let value):
         setWidth(value)
      }
   }
}

// MARK: - Stack State

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

extension ViewModelProtocol where Self: Stateable, View: UIStackView {
   func applyState(_ state: StackState) {
      switch state {
      // Stack View
      case .distribution(let value):
         setDistribution(value)
      case .axis(let value):
         setAxis(value)
      case .spacing(let value):
         setSpacing(value)
      case .alignment(let value):
         setAlignment(value)
      case .padding(let value):
         setPadding(value)
      case .models(let value):
         setModels(value)
      case .backView(let value, let value2):
         setBackView(value, inset: value2)
      case .backImage(let image):
         setBackImage(image)

      // View
      case .backColor(let value):
         setBackColor(value)
      case .height(let value):
         setHeight(value)
      case .cornerRadius(let value):
         setCornerRadius(value)
      case .borderColor(let value):
         setBorderColor(value)
      case .borderWidth(let value):
         setBorderWidth(value)
      case .hidden(let value):
         setHidden(value)
      }
   }
}

// MARK: - Label State

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
         setText(value)
      case .font(let value):
         setFont(value)
      case .color(let value):
         setColor(value)
      case .numberOfLines(let value):
         setNumberOfLines(value)
      case .alignment(let value):
         setAlignment(value)
      case .padding(let value):
         setPadding(value)
      case .padLeft(let value):
         setPadLeft(value)
      case .padRight(let value):
         setPadRight(value)
      case .padUp(let value):
         setPadTop(value)
      case .padBottom(let value):
         setPadBottom(value)
      }
   }
}

// MARK: - Image view state

enum ImageViewState {
   case image(UIImage)
   case contentMode(UIView.ContentMode)
   case padding(UIEdgeInsets)
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   func applyState(_ state: ImageViewState) {
      switch state {
      case .image(let value):
         setImage(value)
      case .contentMode(let value):
         setContentMode(value)
      case .padding(let value):
         setPadding(value)
      }
   }
}

// MARK: - Button states

enum ButtonState {
   case enabled(Bool)
   case selected(Bool)
   case title(String)
   case textColor(UIColor)
   case font(UIFont)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case height(CGFloat)
   case image(UIImage)
   case tint(UIColor)
   case vertical(Bool)
   case hidden(Bool)
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   func applyState(_ state: ButtonState) {
      switch state {
      case .enabled(let value):
         setEnabled(value)
      case .selected(let value):
         setSelected(value)
      case .title(let value):
         setTitle(value)
      case .textColor(let value):
         setTextColor(value)
      case .backColor(let value):
         setBackColor(value)
      case .cornerRadius(let value):
         setCornerRadius(value)
      case .height(let value):
         setHeight(value)
      case .font(let value):
         setFont(value)
      case .image(let value):
         setImage(value)
      case .tint(let value):
         setTint(value)
      case .vertical(let value):
         setVertical(value)
      case .hidden(let value):
         setHidden(value)
      }
   }
}

// MARK: - TextFieldModel state

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
      case .text(let value):
         setText(value)
      case .placeholder(let value):
         setPlaceholder(value)
      case .backColor(let value):
         setBackColor(value)
      case .font(let value):
         setFont(value)
      case .clearButtonMode(let value):
         setClearButtonMode(value)
      case .padding(let value):
         setPadding(value)
      case .height(let value):
         setHeight(value)
      case .widht(let value):
         setWidth(value)

      case .cornerRadius(let value):
         setCornerRadius(value)
      case .borderColor(let value):
         setBorderColor(value)
      case .borderWidth(let value):
         setBorderWidth(value)
      case .hidden(let value):
         setHidden(value)
      case .size(let value):
         setSize(value)
      case .zPosition(let value):
         setZPosition(value)
      case .placing(let value):
         setPlacing(value)
      }
   }
}
