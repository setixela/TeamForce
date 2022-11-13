//
//  FeedCommentsBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import ReactiveWorks

enum FeedCommentsState {
   case sendButtonDisabled
   case sendButtonEnabled
}

final class FeedCommentsBlock<Design: DSP>: DoubleStacksModel, Designable {
   lazy var commentTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         CommentPresenters<Design>().commentCellPresenter,
         SpacerPresenter.presenter
      ]))

   lazy var commentField = TextFieldModel()
      .set(Design.state.textField.default)
      .placeholder(Design.Text.title.comment)
      .placeholderColor(Design.color.textFieldPlaceholder)

   lazy var sendButton = ButtonSelfModable()
      .image(Design.icon.tablerBrandTelegram)
      .set(Design.state.button.default)
      .width(Design.params.buttonHeight)
      .onSelfModeChanged(\.inactive) {
         $0?.set(Design.state.button.inactive)
      }
      .onSelfModeChanged(\.normal) {
         $0?.set(Design.state.button.default)
      }
      .setSelfMode(\.inactive)

   private lazy var commentPanel = StackModel()
      .arrangedModels([
         commentField,
         sendButton
      ])
      .axis(.horizontal)
      .spacing(8)

   private lazy var hereIsEmptySpacedBlock = HereIsEmptySpacedBlock<Design>()
      .hidden(true)
   override func start() {
      super.start()

      bodyStack.arrangedModels([
         hereIsEmptySpacedBlock,
         commentTableModel,
         Spacer()
      ])

      footerStack.arrangedModels([
         Spacer(16),
         commentPanel
      ])
   }
}

extension FeedCommentsBlock: SetupProtocol {
   func setup(_ data: [Comment]) {
      if data.count != 0 {
         hereIsEmptySpacedBlock.hidden(true)
         commentTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
      } else {
         hereIsEmptySpacedBlock.hidden(false)
      }
   }
}

extension FeedCommentsBlock: StateMachine {
   func setState(_ state: FeedCommentsState) {
      switch state {
      case .sendButtonDisabled:
         sendButton.setSelfMode(\.inactive)
      case .sendButtonEnabled:
         sendButton.setSelfMode(\.normal)
      }
   }
}
