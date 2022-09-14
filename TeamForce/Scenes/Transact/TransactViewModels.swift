//
//  TransactScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 18.08.2022.
//
import ReactiveWorks
import UIKit

// final class

final class TransactViewModels<Design: DSP>: Designable {
   //
   lazy var balanceInfo = Design.model.transact.balanceInfo
   lazy var userSearchTextField = Design.model.transact.userSearchTextField
   lazy var reasonTextView = Design.model.transact.reasonInputTextView
   lazy var amountInputModel = Design.model.transact.amountIputViewModel
   lazy var foundUsersList = Design.model.transact.foundUsersList
   lazy var addPhotoButton = Design.model.transact.addPhotoButton
   lazy var sendButton = Design.model.transact.sendButton
   lazy var pickedImages = Design.model.transact.pickedImagesPanel
   lazy var notFoundBlock = Design.model.transact.userNotFoundInfoBlock
   lazy var options = Design.model.transact.transactOptionsBlock
}
