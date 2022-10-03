//
//  FeedCommentsBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import ReactiveWorks

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

   lazy var sendButton = ButtonModel()
      .image(Design.icon.tablerBrandTelegram)
      .set(Design.state.button.default)
      .width(Design.params.buttonHeight)

   private lazy var commentPanel = StackModel()
      .arrangedModels([
         commentField,
         sendButton
      ])
      .axis(.horizontal)
      .spacing(8)

   override func start() {
      super.start()

      bodyStack.arrangedModels([
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
      commentTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
