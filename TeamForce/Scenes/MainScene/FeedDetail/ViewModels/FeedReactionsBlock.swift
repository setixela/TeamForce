//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import ReactiveWorks
import UIKit

final class FeedReactionsBlock<Design: DSP>: StackModel, Designable {
   lazy var filterButtons = FeedReactionsFilterButtons<Design>()
      .hidden(true)
   lazy var reactedUsersTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         ReactionsPresenters<Design>().reactionsCellPresenter,
         SpacerPresenter.presenter
      ]))

   override func start() {
      super.start()
      filterButtons.buttonAll.setMode(\.normal)
      
      arrangedModels([
         Spacer(8),
         filterButtons,
         reactedUsersTableModel
      ])
   }
}

extension FeedReactionsBlock: SetupProtocol {
   func setup(_ data: [ReactItem]) {
      reactedUsersTableModel.set(.items(data + [SpacerItem(size: Grid.x64.value)]))
   }
}
