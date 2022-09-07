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
         backColor(value)
      case .height(let value):
         height(value)
      case .cornerRadius(let value):
         cornerRadius(value)
      case .borderColor(let value):
         borderColor(value)
      case .borderWidth(let value):
         borderWidth(value)
      case .hidden(let value):
         hidden(value)
      case .size(let value):
         size(value)
      case .zPosition(let value):
         zPosition(value)
      case .placing(let value):
         placing(value)
      case .width(let value):
         width(value)
      }
   }
}

// MARK: - Stack State

enum StackState {
   case distribution(StackViewExtended.Distribution)
   case axis(NSLayoutConstraint.Axis)
   case spacing(CGFloat)
   case alignment(StackViewExtended.Alignment)
   case padding(UIEdgeInsets)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case borderWidth(CGFloat)
   case borderColor(UIColor)
   case height(CGFloat)
   case arrangedModels([UIViewModel])
   case hidden(Bool)
   case backView(UIView, inset: UIEdgeInsets = .zero)
   case backImage(UIImage)
   case backViewModel(UIViewModel, inset: UIEdgeInsets = .zero)
   case shadow(Shadow)
}

extension ViewModelProtocol where Self: Stateable, View: StackViewExtended {
   func applyState(_ state: StackState) {
      switch state {
      // Stack View
      case .distribution(let value):
         distribution(value)
      case .axis(let value):
         axis(value)
      case .spacing(let value):
         spacing(value)
      case .alignment(let value):
         alignment(value)
      case .padding(let value):
         padding(value)
      case .arrangedModels(let value):
         arrangedModels(value)
      case .backView(let value, let value2):
         backView(value, inset: value2)
      case .backImage(let image):
         backImage(image)

      // View
      case .backColor(let value):
         backColor(value)
      case .height(let value):
         height(value)
      case .cornerRadius(let value):
         cornerRadius(value)
      case .borderColor(let value):
         borderColor(value)
      case .borderWidth(let value):
         borderWidth(value)
      case .hidden(let value):
         hidden(value)
      case .backViewModel(let value, let inset):
         backViewModel(value, inset: inset)
      case .shadow(let value):
         shadow(value)
      }
   }
}

// MARK: - Label State

enum LabelState {
   case text(String)
   case font(UIFont)
   case textColor(UIColor)
   case numberOfLines(Int)
   case alignment(NSTextAlignment)
   case attributedText(NSAttributedString)
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
         text(value)
      case .font(let value):
         font(value)
      case .textColor(let value):
         textColor(value)
      case .numberOfLines(let value):
         numberOfLines(value)
      case .alignment(let value):
         alignment(value)
      case .attributedText(let value):
         attributedText(value)
      case .padding(let value):
         padding(value)
      case .padLeft(let value):
         padLeft(value)
      case .padRight(let value):
         padRight(value)
      case .padUp(let value):
         padTop(value)
      case .padBottom(let value):
         padBottom(value)
      }
   }
}

// MARK: - Image view state

enum ImageViewState {
   case image(UIImage)
   case contentMode(UIView.ContentMode)
   case padding(UIEdgeInsets)
   case imageTintColor(UIColor)
}

extension ViewModelProtocol where Self: Stateable, View: PaddingImageView {
   func applyState(_ state: ImageViewState) {
      switch state {
      case .image(let value):
         image(value)
      case .contentMode(let value):
         contentMode(value)
      case .padding(let value):
         padding(value)
      case .imageTintColor(let value):
         imageTintColor(value)
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

   case borderWidth(CGFloat)
   case borderColor(UIColor)

   case imageInset(UIEdgeInsets)
}

extension ViewModelProtocol where Self: Stateable, View: ButtonExtended {
   func applyState(_ state: ButtonState) {
      switch state {
      case .enabled(let value):
         enabled(value)
      case .selected(let value):
         selected(value)
      case .title(let value):
         title(value)
      case .textColor(let value):
         textColor(value)
      case .backColor(let value):
         backColor(value)
      case .cornerRadius(let value):
         cornerRadius(value)
      case .height(let value):
         height(value)
      case .font(let value):
         font(value)
      case .image(let value):
         image(value)
      case .tint(let value):
         tint(value)
      case .vertical(let value):
         vertical(value)
      case .hidden(let value):
         hidden(value)

      case .borderColor(let value):
         borderColor(value)
      case .borderWidth(let value):
         borderWidth(value)

      case .imageInset(let value):
         imageInset(value)
      }
   }
}

// MARK: - TextFieldModel state

enum TextFieldState {
   case text(String)
   case placeholder(String)
   case backColor(UIColor)
   case textColor(UIColor)
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
         text(value)
      case .placeholder(let value):
         placeholder(value)
      case .backColor(let value):
         backColor(value)
      case .textColor(let value):
         textColor(value)
      case .font(let value):
         font(value)
      case .clearButtonMode(let value):
         clearButtonMode(value)
      case .padding(let value):
         padding(value)
      case .height(let value):
         height(value)
      case .widht(let value):
         width(value)

      case .cornerRadius(let value):
         cornerRadius(value)
      case .borderColor(let value):
         borderColor(value)
      case .borderWidth(let value):
         borderWidth(value)
      case .hidden(let value):
         hidden(value)
      case .size(let value):
         size(value)
      case .zPosition(let value):
         zPosition(value)
      case .placing(let value):
         placing(value)
      }
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   func applyState(_ state: LabelState) {
      switch state {
      case .text(let value):
         text(value)
      case .font(let value):
         font(value)
      case .textColor(let value):
         textColor(value)
      case .numberOfLines:
         break
      case .alignment(let value):
         alignment(value)
      case .padding(let value):
         padding(value)
      case .padLeft:
         break
      case .padRight:
         break
      case .padUp:
         break
      case .padBottom:
         break
      case .attributedText(_):
         break
      }
   }
}

// MARK: - Text View

extension ViewModelProtocol where Self: Stateable, View: UITextView {
   func applyState(_ state: TextViewState) {
      switch state {
      case .text(let string):
         text(string)
      case .placeholder(let string):
         text(string)
      case .font(let value):
         font(value)
      case .padding(let value):
         padding(value)
      case .height(let value):
         height(value)
      case .width(let value):
         width(value)
      }
   }
}

extension ViewModelProtocol where Self: Stateable, View: UITextView {
   func applyState(_ state: LabelState) {
      switch state {
      case .text(let value):
         text(value)
      case .font(let value):
         font(value)
      case .textColor(let value):
         textColor(value)
      case .numberOfLines:
         break
      case .alignment(let value):
         alignment(value)
      case .padding(let value):
         padding(value)
      case .padLeft:
         break
      case .padRight:
         break
      case .padUp:
         break
      case .padBottom:
         break
      case .attributedText(_):
         break
      }
   }
}
