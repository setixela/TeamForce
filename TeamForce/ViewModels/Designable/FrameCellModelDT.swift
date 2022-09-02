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

final class FrameCellModelDT<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
   Designable
{
   typealias State = StackState

   private lazy var headerLabel = Design.label.body2
      .textColor(Design.color.textInvert)
   private lazy var textLabel = Design.label.headline4
      .textColor(Design.color.textInvert)
   private lazy var captionLabel = Design.label.default
      .textColor(Design.color.textInvert)

   override func start() {
      set(.axis(.vertical))
      set(.padding(.init(top: 28, left: 20, bottom: 22, right: 16)))
      set(.cornerRadius(Design.params.cornerRadiusMedium))
      width(193)
      set(.models([
         headerLabel,
         Spacer(10),
         textLabel,
         Spacer(54),
         captionLabel
      ]))
      backViewModel(ImageViewModel()
         .image(Design.icon.coinBackground)
         .padding(.horizontalShift(40))
      )
   }
}

extension FrameCellModelDT: Stateable2 {
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

final class BalanceStatusFrameDT<Design: DSP>:
   Combos<SComboMRDD<ImageViewModel, LabelModel, LabelModel, ViewModel>>, Designable
{
   required init() {
      super.init()

      alignment(.center)
      cornerRadius(Design.params.cornerRadius)
      height(Design.params.infoFrameHeight)
      padding(.init(top: 8, left: 14, bottom: 8, right: 14))
      setMain {
         $0.size(.square(24))
      } setRight: {
         $0
            .set(Design.state.label.default)
            .padLeft(15)
      } setDown: {
         $0
            .set(Design.state.label.default)
            .padLeft(15)
      } setDown2: {
         $0
            .height(10)
      }
   }
}




