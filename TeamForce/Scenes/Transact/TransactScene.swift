//
//  TransactModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 29.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactEvents: InitProtocol {
   var cancelled: Void?
   var sendButtonPressed: Void?
   var finishWithSuccess: StatusViewInput?
   var finishWithError: Void?
}

enum TransactState {
   case initial
   case error

   case loadTokensSuccess

   case loadBalanceSuccess(Int)

   case loadUsersListSuccess([FoundUser])

   case presentFoundUser([FoundUser])
   case presentUsers([FoundUser])
   case listOfFoundUsers([FoundUser])

   case userSelectedSuccess(FoundUser, Int)

   case userSearchTFDidEditingChangedSuccess

   case sendCoinSuccess((String, SendCoinRequest))
   case sendCoinError

   case resetCoinInput
   case coinInputSuccess(String, Bool)
   case reasonInputSuccess(String, Bool)

   case presentImagePicker
   case presentPickedImage(UIImage)
   case setHideAddPhotoButton(Bool)

   case presentTagsSelector(Set<Tag>)
   case updateSelectedTags(Set<Tag>)

   case sendButtonPressed
   case cancelButtonPressed
}

final class TransactScene<Asset: AssetProtocol>: ModalDoubleStackModel<Asset>, Scenarible2, Eventable {
   typealias Events = TransactEvents
   typealias State = StackState

   var events: [Int: LambdaProtocol?] = [:]

   private lazy var works = TransactWorks<Asset>()

   lazy var scenario: Scenario = TransactScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: TransactScenarioEvents(
         userSearchTXTFLDBeginEditing: viewModels.userSearchTextField.on(\.didBeginEditing),
         userSearchTFDidEditingChanged: viewModels.userSearchTextField.on(\.didEditingChanged),
         userSelected: viewModels.foundUsersList.onEvent(\.didSelectRow),
         sendButtonEvent: viewModels.sendButton.on(\.didTap),
         amountInputChanged: viewModels.amountInputModel.textField.on(\.didEditingChanged),
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged),
         anonymousSetOff: viewModels.options.anonimParamModel.switcher.on(\.turnedOff),
         anonymousSetOn: viewModels.options.anonimParamModel.switcher.on(\.turnedOn),
         presentTagsSelectorDidTap: viewModels.options.tagsPanelSwitcher.optionModel.on(\.didTap),
         enableTags: viewModels.options.tagsPanelSwitcher.on(\.turnedOn),
         disableTags: viewModels.options.tagsPanelSwitcher.on(\.turnedOff),
         removeTag: viewModels.options.tagsPanelSwitcher.optionModel.on(\.didTapTag),
         setTags: tagList.on(\.saveButtonDidTap),
         cancelButtonDidTap: closeButton.on(\.didTap)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: ImagePickingScenarioEvents(
         startImagePicking: viewModels.addPhotoButton.on(\.didTap),
         addImageToBasket: imagePicker.onEvent(\.didImagePicked),
         removeImageFromBasket: viewModels.pickedImages.on(\.didCloseImage),
         didMaximumReach: viewModels.pickedImages.on(\.didMaximumReached)
      )
   )

   private lazy var viewModels = TransactViewModels<Design>()

   private lazy var viewModelsWrapper = ScrollViewModelY()
      .set(.spacing(Grid.x16.value))
      .set(.arrangedModels([
         viewModels.balanceInfo,
         viewModels.foundUsersList,
         viewModels.amountInputModel,
         viewModels.reasonTextView,
         viewModels.pickedImages.lefted(),
         viewModels.addPhotoButton,
         viewModels.options,
         Grid.x48.spacer
      ]))

   private lazy var activityIndicator = Design.model.common.activityIndicator
   private lazy var errorInfoBlock = Design.model.common.connectionErrorBlock
   private lazy var imagePicker = Design.model.common.imagePicker

   private lazy var tagList = TagList<Asset>()

   private lazy var bottomPopupPresenter = BottomPopupPresenter()

   private var currentState = TransactState.initial

   private weak var vcModel: UIViewController?

   convenience init(vcModel: UIViewController?) {
      self.init()

      self.vcModel = vcModel
   }

   // MARK: - Start

   override func start() {
      super.start()

      configure()

      view.on(\.willAppear) { [weak self] in
         self?.viewModels.foundUsersList.set(.items([]))
         self?.scenario.start()
         self?.scenario2.start()
         self?.setToInitialCondition()
      }
   }

   func configure() {
      //
      title
         .set(Design.state.label.body3)
         .text(Design.Text.title.newTransact)
      //
      bodyStack
         .safeAreaOffsetDisabled()
         .axis(.vertical)
         .distribution(.fill)
         .alignment(.fill)
         .arrangedModels([
            //
            viewModels.userSearchTextField,
            Grid.x8.spacer,

            viewModels.notFoundBlock.hidden(true),
            errorInfoBlock.hidden(true),
            activityIndicator.hidden(false),

            viewModelsWrapper
         ])
      //
      footerStack
         .arrangedModels([
            viewModels.sendButton
         ])
   }
}

extension TransactScene: StateMachine {
   func setState(_ state: TransactState) {
      debug(state)

      switch state {
      case .initial:
         activityIndicator.hidden(false)
      //
      case .error:
         viewModels.userSearchTextField.hidden(true)
         activityIndicator.hidden(true)
         presentFoundUsers(users: [])

      //
      case .loadTokensSuccess:
         activityIndicator.hidden(false)

      //
      case .loadBalanceSuccess(let balance):
         viewModels.balanceInfo.models.down.label.text(String(balance))
      //
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
         activityIndicator.hidden(true)
      //
      //
      case .presentFoundUser(let users):
         viewModels.foundUsersList.hidden(true)
         activityIndicator.hidden(true)
         presentFoundUsers(users: users)

      //
      case .presentUsers(let users):
         viewModels.foundUsersList.hidden(true)
         activityIndicator.hidden(true)
         presentFoundUsers(users: users)
      //
      case .listOfFoundUsers(let users):
         activityIndicator.hidden(true)
         presentFoundUsers(users: users)
      //
      case .userSelectedSuccess(_, let index):
         viewModels.userSearchTextField.hidden(true)

         if case .userSelectedSuccess = currentState {
            UIView.animate(withDuration: 0.3) {
               self.viewModels.userSearchTextField.hidden(false)
               self.viewModels.foundUsersList.hidden(true)
               self.currentState = .initial
            }
            self.applySelectUserMode()
            return
         }

         currentState = state

         viewModelsWrapper.set(.scrollToTop(animated: true))
         presentBalanceInfo()

         UIView.animate(withDuration: 0.1) {
            self.viewModels.foundUsersList.set(.removeAllExceptIndex(index))
            self.view.layoutIfNeeded()
         } completion: { _ in
            self.applyReadyToSendMode()
         }
      //
      case .userSearchTFDidEditingChangedSuccess:
         activityIndicator.hidden(false)
         viewModels.foundUsersList.set(.items([]))
         applySelectUserMode()
      //
      case .sendCoinSuccess(let tuple):

         let sended = StatusViewInput(sendCoinInfo: tuple.1,
                                      username: tuple.0,
                                      foundUser: viewModels.foundUsersList.items.first as! FoundUser)
         send(\.finishWithSuccess, sended)
         setToInitialCondition()
      //
      case .sendCoinError:
         send(\.finishWithError)
      case .resetCoinInput:
         viewModels.amountInputModel.setState(.noInput)
      case .coinInputSuccess(let text, let isCorrect):
         viewModels.amountInputModel.textField.set(.text(text))
         if isCorrect {
            viewModels.amountInputModel.setState(.normal(text))
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.amountInputModel.textField.set(.text(text))
            viewModels.sendButton.set(Design.state.button.inactive)
         }
      //
      case .reasonInputSuccess(let text, let isCorrect):
         viewModels.reasonTextView.set(.text(text))
         if isCorrect {
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.reasonTextView.set(.text(text))
            viewModels.sendButton.set(Design.state.button.inactive)
         }
      //
      case .presentPickedImage(let image):
         viewModels.pickedImages.addButton(image: image)
      //
      case .setHideAddPhotoButton(let value):
         viewModels.addPhotoButton.hidden(value)
      //
      case .sendButtonPressed:
         send(\.sendButtonPressed)
      //
      case .cancelButtonPressed:
         send(\.cancelled)
      //
      case .presentImagePicker:
         guard let baseVC = vcModel else { return }
         imagePicker.sendEvent(\.presentOn, baseVC)
      //
      case .presentTagsSelector(let tags):

         bottomPopupPresenter.send(\.present, (model: tagList, onView: vcModel?.view.rootSuperview))

         tagList.setState(.selectTags(tags))
         tagList.on(\.exit, self) {
            $0.bottomPopupPresenter.send(\.hide)
         }
         tagList.closeButton.on(\.didTap, self) {
            $0.bottomPopupPresenter.send(\.hide)
         }
      //
      case .updateSelectedTags(let tags):
         if tags.isEmpty {
            viewModels.options.tagsPanelSwitcher.optionModel.setState(.clear)
         } else {
            viewModels.options.tagsPanelSwitcher.optionModel.setState(.selected(tags))
         }
         tagList.saveButton.set(Design.state.button.default)
      }
   }
}

private extension TransactScene {
   private func setToInitialCondition() {
      clearFields()

      viewModels.sendButton.set(Design.state.button.inactive)
      viewModels.amountInputModel.setState(.noInput)

      currentState = .initial
      setState(.initial)
      applySelectUserMode()
   }

   private func clearFields() {
      viewModels.userSearchTextField.text("")
      viewModels.amountInputModel.textField.text("")
      viewModels.reasonTextView
         .text("")
         .placeholder(Design.Text.title.reasonPlaceholder)
      viewModels.options.tagsPanelSwitcher.labelSwitcher.switcher.applyState(.turnOff)
      viewModels.options.tagsPanelSwitcher.optionModel.setState(.clear)
      viewModels.options.tagsPanelSwitcher.optionModel.hidden(true)
      tagList.setState(.clear)
   }

   func applySelectUserMode() {
      footerStack.hidden(true, isAnimated: true)
      viewModels.options.hidden(true, isAnimated: true)
      viewModels.addPhotoButton.hidden(true, isAnimated: true)
      viewModels.pickedImages.hidden(true, isAnimated: true)
      viewModels.reasonTextView.hidden(true, isAnimated: true)
      viewModels.amountInputModel.set(.hidden(true, isAnimated: true))
      viewModels.userSearchTextField.hidden(false, isAnimated: true)
      viewModels.balanceInfo.set(.hidden(true, isAnimated: true))

      viewModels.notFoundBlock.hidden(true)

      view.endEditing(true)
   }

   func presentBalanceInfo() {
      viewModels.notFoundBlock.hidden(true, isAnimated: true)
      viewModels.balanceInfo.set(.hidden(false, isAnimated: true))
   }

   func applyReadyToSendMode() {
      viewModels.amountInputModel.hidden(false, isAnimated: true)
      viewModels.reasonTextView.hidden(false, isAnimated: true)
      viewModels.pickedImages.hidden(false, isAnimated: true)
      viewModels.addPhotoButton.hidden(false, isAnimated: true)
      viewModels.options.hidden(false, isAnimated: true)
      footerStack.hidden(false, isAnimated: true)

      view.endEditing(true)
   }
}

private extension TransactScene {
   func presentFoundUsers(users: [FoundUser]) {
      viewModels.foundUsersList.set(.items(users))
      viewModels.foundUsersList.hiddenAnimated(users.isEmpty ? true : false, duration: 0.5)

      viewModels.notFoundBlock.hiddenAnimated(!users.isEmpty, duration: 0.5)
   }
}
