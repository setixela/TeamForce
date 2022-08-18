//
//  FrameCellModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import ReactiveWorks
import UIKit

enum FrameCellState {
   case text(String)
   case header(String)
   case caption(String)
}

final class FrameCellModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
   Designable
{
   typealias State = StackState

   private lazy var headerLabel = Design.label.body2
      .set_color(Design.color.textInvert)
   private lazy var textLabel = Design.label.headline4
      .set_color(Design.color.textInvert)
   private lazy var captionLabel = Design.label.default
      .set_color(Design.color.textInvert)

   override func start() {
      set(.axis(.vertical))
      set(.padding(.init(top: 28, left: 20, bottom: 22, right: 16)))
      set(.cornerRadius(Design.params.cornerRadiusMedium))
      set_width(193)
      set(.models([
         headerLabel,
         Spacer(10),
         textLabel,
         Spacer(54),
         captionLabel
      ]))
   }
}

extension FrameCellModel: Stateable2 {
   func applyState(_ state: FrameCellState) {
      switch state {
      case .text(let string):
         textLabel.set(.text(string))
      case .header(let string):
         headerLabel.set(.text(string))
      case .caption(let string):
         captionLabel.set(.text(string))
      }
   }
}

final class BalanceStatusFrame<Design: DSP>:
   Combos<SComboMRDD<ImageViewModel, LabelModel, LabelModel, ViewModel>>, Designable
{
   required init() {
      super.init()

      set_alignment(.center)
      set_cornerRadius(Design.params.cornerRadius)
      set_height(Design.params.infoFrameHeight)
      set_padding(.init(top: 8, left: 14, bottom: 8, right: 14))
      setMain {
         $0.set_size(.square(24))
      } setRight: {
         $0
            .set_font(Design.font.default)
            .set_padLeft(15)
      } setDown: {
         $0
            .set_font(Design.font.default)
            .set_padLeft(15)
      } setDown2: {
         $0
            .set_height(10)
      }
   }
}

enum ScrollState {
   case models([UIViewModel])
   case spacing(CGFloat)
}

final class ScrollViewModelX: BaseViewModel<UIScrollView> {
   private lazy var stack = StackModel()
      .set_axis(.horizontal)

   private var spacing: CGFloat = 0

   override func start() {
      view.addSubview(stack.uiView)

      stack.view.translatesAutoresizingMaskIntoConstraints = false
      stack.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      stack.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      stack.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      stack.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
   }
}

extension ScrollViewModelX: Stateable2 {
   func applyState(_ state: ScrollState) {
      switch state {
      case .models(let array):
         array.enumerated().forEach {
            stack.view.addArrangedSubview($0.1.uiView)
         }
      case .spacing(let value):
         stack.view.spacing = value
      }
   }
}

