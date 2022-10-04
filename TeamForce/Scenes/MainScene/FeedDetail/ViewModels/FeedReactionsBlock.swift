//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import ReactiveWorks
import UIKit

final class FeedReactionsBlock<Design: DSP>: StackModel, Designable {
   lazy var likeButtonsPanel = FeedReactionsFilterButtons<Design>()
   lazy var reactedUsersTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         ReactionsPresenters<Design>().reactionsCellPresenter,
         SpacerPresenter.presenter
      ]))

   override func start() {
      super.start()
      arrangedModels([
         Spacer(8),
         likeButtonsPanel,
         reactedUsersTableModel
      ])
   }
}

extension FeedReactionsBlock: SetupProtocol {
   func setup(_ data: [ReactItem]) {
      reactedUsersTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
