//
//  FeedScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import Foundation
import ReactiveWorks

final class FeedScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>, Assetable, Stateable2 {
   typealias State = ViewState
   typealias State2 = StackState

   private lazy var feedTableModel = TableItemsModel<Design>()
      .set_backColor(Design.color.background)

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      set_axis(.vertical)
      set_arrangedModels([
         Grid.x16.spacer,
         feedTableModel,
         //Spacer(88),
      ])

      useCase.getFeed.work
         .retainBy(useCase.retainer)
         .doAsync()
         .onSuccess {
            log($0)
         }
         .onFail {
            errorLog("Feed load API ERROR")
         }
   }

   lazy var feedCellPresenter: Presenter<Feed, ViewModel> = Presenter<Feed, ViewModel> { work in

      let feed = work.unsafeInput

      let reactionsBlock = StackModel()
         .set_axis(.horizontal)
         .set_spacing(4)

      let tagBlock = StackModel()
         .set_axis(.horizontal)
         .set_spacing(4)

      let messageButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.messageCloud)
            $1.set_text(String.randomInt(500))
         }

      let likeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.like)
            $1.set_text(String.randomInt(500))
         }

      let dislikeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.dislike)
            $1.set_text(String.randomInt(500))
         }


      let comboMR = Combos<SComboMR<ImageViewModel, ViewModel>>()
         .setAll { avatar, infoBlock in

         }
   }
}

extension String {
   static func randomInt(_ max: Int) -> String {
      String(Int.random(in: 0...max))
   }
}

final class ReactionButton<Design: DSP>: Combos<SComboMR<ImageViewModel, LabelModel>>, Designable {
//   required init() {
//      
//   }
}
