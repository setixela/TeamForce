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
         reactedUsersTableModel,
         Spacer()
      ])
   }
}

extension FeedReactionsBlock: SetupProtocol {
   func setup(_ data: [Item]) {
      reactedUsersTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
