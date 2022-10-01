//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import Foundation

struct FeedReactionsBlock<Design: DSP>: Designable {
   lazy var likeButtonsPanel = StackModel()
   lazy var reactedUserList = TableItemsModel<Design>()
}
