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

   override func start() {
      super.start()

      bodyStack.arrangedModels([
         commentTableModel
      ])

      footerStack.arrangedModels([
         commentField
      ])
   }
}
