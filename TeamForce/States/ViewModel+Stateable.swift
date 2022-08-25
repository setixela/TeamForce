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
         set_backColor(value)
      case .height(let value):
         set_height(value)
      case .cornerRadius(let value):
         set_cornerRadius(value)
      case .borderColor(let value):
         set_borderColor(value)
      case .borderWidth(let value):
         set_borderWidth(value)
      case .hidden(let value):
         set_hidden(value)
      case .size(let value):
         set_size(value)
      case .zPosition(let value):
         set_zPosition(value)
      case .placing(let value):
         set_placing(value)
      case .width(let value):
         set_width(value)
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
   case models([UIViewModel])
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
         set_distribution(value)
      case .axis(let value):
         set_axis(value)
      case .spacing(let value):
         set_spacing(value)
      case .alignment(let value):
         set_alignment(value)
      case .padding(let value):
         set_padding(value)
      case .models(let value):
         set_arrangedModels(value)
      case .backView(let value, let value2):
         set_backView(value, inset: value2)
      case .backImage(let image):
         set_backImage(image)

      // View
      case .backColor(let value):
         set_backColor(value)
      case .height(let value):
         set_height(value)
      case .cornerRadius(let value):
         set_cornerRadius(value)
      case .borderColor(let value):
         set_borderColor(value)
      case .borderWidth(let value):
         set_borderWidth(value)
      case .hidden(let value):
         set_hidden(value)
      case .backViewModel(let value, let inset):
         set_backViewModel(value, inset: inset)
      case .shadow(let value):
         set_shadow(value)
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
         set_text(value)
      case .font(let value):
         set_font(value)
      case .textColor(let value):
         set_textColor(value)
      case .numberOfLines(let value):
         set_numberOfLines(value)
      case .alignment(let value):
         set_alignment(value)
      case .padding(let value):
         set_padding(value)
      case .padLeft(let value):
         set_padLeft(value)
      case .padRight(let value):
         set_padRight(value)
      case .padUp(let value):
         set_padTop(value)
      case .padBottom(let value):
         set_padBottom(value)
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
         set_image(value)
      case .contentMode(let value):
         set_contentMode(value)
      case .padding(let value):
         set_padding(value)
      case .imageTintColor(let value):
         set_imageTintColor(value)
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
         set_enabled(value)
      case .selected(let value):
         set_selected(value)
      case .title(let value):
         set_title(value)
      case .textColor(let value):
         set_textColor(value)
      case .backColor(let value):
         set_backColor(value)
      case .cornerRadius(let value):
         set_cornerRadius(value)
      case .height(let value):
         set_height(value)
      case .font(let value):
         set_font(value)
      case .image(let value):
         set_image(value)
      case .tint(let value):
         set_tint(value)
      case .vertical(let value):
         set_vertical(value)
      case .hidden(let value):
         set_hidden(value)

      case .borderColor(let value):
         set_borderColor(value)
      case .borderWidth(let value):
         set_borderWidth(value)

      case .imageInset(let value):
         set_imageInset(value)
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
         set_text(value)
      case .placeholder(let value):
         set_placeholder(value)
      case .backColor(let value):
         set_backColor(value)
      case .textColor(let value):
         set_textColor(value)
      case .font(let value):
         set_font(value)
      case .clearButtonMode(let value):
         set_clearButtonMode(value)
      case .padding(let value):
         set_padding(value)
      case .height(let value):
         set_height(value)
      case .widht(let value):
         set_width(value)

      case .cornerRadius(let value):
         set_cornerRadius(value)
      case .borderColor(let value):
         set_borderColor(value)
      case .borderWidth(let value):
         set_borderWidth(value)
      case .hidden(let value):
         set_hidden(value)
      case .size(let value):
         set_size(value)
      case .zPosition(let value):
         set_zPosition(value)
      case .placing(let value):
         set_placing(value)
      }
   }
}

extension ViewModelProtocol where Self: Stateable, View: PaddingTextField {
   func applyState(_ state: LabelState) {
      switch state {
      case .text(let value):
         set_text(value)
      case .font(let value):
         set_font(value)
      case .textColor(let value):
         set_textColor(value)
      case .numberOfLines:
         break
      case .alignment(let value):
         set_alignment(value)
      case .padding(let value):
         set_padding(value)
      case .padLeft:
         break
      case .padRight:
         break
      case .padUp:
         break
      case .padBottom:
         break
      }
   }
}

// MARK: - Text View

extension ViewModelProtocol where Self: Stateable, View: UITextView {
   func applyState(_ state: TextViewState) {
      switch state {
      case .text(let string):
         set_text(string)
      case .placeholder(let string):
         set_text(string)
      case .font(let font):
         set_font(font)
      case .padding(let value):
         set_padding(value)
      case .height(let value):
         set_height(value)
      case .width(let value):
         set_width(value)
      }
   }
}

extension ViewModelProtocol where Self: Stateable, View: UITextView {
   func applyState(_ state: LabelState) {
      switch state {
      case .text(let value):
         set_text(value)
      case .font(let value):
         set_font(value)
      case .textColor(let value):
         set_textColor(value)
      case .numberOfLines:
         break
      case .alignment(let value):
         set_alignment(value)
      case .padding(let value):
         set_padding(value)
      case .padLeft:
         break
      case .padRight:
         break
      case .padUp:
         break
      case .padBottom:
         break
      }
   }
}
