//
//  FeedScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import ReactiveWorks
import UIKit

final class FeedScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Assetable,
   Stateable2,
   Communicable
{
   typealias State = ViewState
   typealias State2 = StackState

   var events = MainSceneEvents()

   private lazy var viewModels = FeedViewModels<Design>()

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      set_axis(.vertical)
      set_arrangedModels([
         viewModels.filterButtons,
         viewModels.feedTableModel
         // Spacer(88),
      ])

      useCase.getFeed
         .doAsync()
         .onSuccess { [weak self] in
            self?.viewModels.feedTableModel.set(.items($0 + [SpacerItem(size: Grid.x64.value)]))
         }
         .onFail {
            errorLog("Feed load API ERROR")
         }

      viewModels.feedTableModel
         .onEvent(\.didScroll) { [weak self] in
            self?.sendEvent(\.didScroll, $0)
         }
         .onEvent(\.willEndDragging) { [weak self] in
            self?.sendEvent(\.willEndDragging, $0)
         }
   }
}

extension String {
   static func randomInt(_ max: Int) -> String {
      String(Int.random(in: 0 ... max))
   }

   static var randomUrlImage: String {
      "https://picsum.photos/200"
   }
}

final class ReactionButton<Design: DSP>: Combos<SComboMR<ImageViewModel, LabelModel>>, Designable {
   required init() {
      super.init()

      setAll {
         $0.set_size(.square(Grid.x16.value))
         $1.set(Design.state.label.caption2)
      }
      set_spacing(8)
      set_backColor(Design.color.backgroundInfoSecondary)
      set_cornerRadius(Design.params.cornerRadiusMini)
      set_height(26)
      set_padding(.sideOffset(8))
   }
}

final class FeedFilterButtons<Design: DSP>: StackModel, Designable {
   lazy var buttonAll = SecondaryButtonDT<Design>()
      .set_title("Все")
      .onEvent(\.didTap) { [weak self] in
         self?.select(0)
      }

   lazy var buttonMy = SecondaryButtonDT<Design>()
      .set_title("Мои")
      .onEvent(\.didTap) { [weak self] in
         self?.select(1)
      }

   lazy var buttonPublic = SecondaryButtonDT<Design>()
      .set_title("Публичные")
      .onEvent(\.didTap) { [weak self] in
         self?.select(2)
      }

   lazy var buttonCalendar = SecondaryButtonDT<Design>()
      .set_image(Design.icon.calendar)
      .set_width(52)
      .set_backColor(Design.color.backgroundBrandSecondary)
      .onEvent(\.didTap) { [weak self] in
         self?.select(3)
      }

   override func start() {
      set_axis(.horizontal)
      set_spacing(Grid.x8.value)
      set_padBottom(8)
      set_arrangedModels([
         buttonAll,
         buttonMy,
         buttonPublic,
         Grid.xxx.spacer,
         buttonCalendar
      ])
   }

   private func deselectAll() {
      buttonAll.setMode(\.normal)
      buttonMy.setMode(\.normal)
      buttonPublic.setMode(\.normal)
   }

   private func select(_ index: Int) {
      deselectAll()
      switch index {
      case 1:
         buttonMy.setMode(\.selected)
      case 2:
         buttonPublic.setMode(\.selected)
      case 3:
         buttonCalendar.setMode(\.selected)
      default:
         buttonAll.setMode(\.selected)
      }
   }
}

final class SecondaryButtonDT<Design: DSP>: ButtonModel, Designable, Modable {
   var modes = ButtonMode()

   override func start() {
      super.start()

      set_padding(.sideOffset(Grid.x14.value))
      set_height(Design.params.buttonSecondaryHeight)
      set_cornerRadius(Design.params.cornerRadiusMini)
      set_shadow(Design.params.cellShadow)
      onModeChanged(\.normal) { [weak self] in
         self?.set_backColor(Design.color.background)
         self?.set_textColor(Design.color.text)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.set_backColor(Design.color.backgroundBrand)
         self?.set_textColor(Design.color.textInvert)
      }
      setMode(\.normal)
   }
}

extension String {
   func drawImage(backColor: UIColor) -> UIImage {
      let text = self
      let attributes = [
         NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
         NSAttributedString.Key.backgroundColor: backColor
      ]
      let textSize = text.size(withAttributes: attributes)

      let renderer = UIGraphicsImageRenderer(size: textSize)
      let image = renderer.image(actions: { _ in
         text.draw(at: CGPoint.zero, withAttributes: attributes)
      })
      return image
   }
}
