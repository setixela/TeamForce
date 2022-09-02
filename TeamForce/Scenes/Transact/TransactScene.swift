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
   var finishWithSuccess: StatusViewInput?
}

enum TransactState {
   case initial
   case loadProfilError
   case loadTransactionsError

   case loadTokensSuccess
   case loadTokensError

   case loadBalanceSuccess(Int)
   case loadBalanceError

   case loadUsersListSuccess([FoundUser])
   case loadUsersListError

   case presentFoundUser([FoundUser])
   case presentUsers([FoundUser])
   case listOfFoundUsers([FoundUser])

   case userSelectedSuccess(FoundUser, Int)

   case userSearchTFDidEditingChangedSuccess

   case sendCoinSuccess((String, SendCoinRequest))
   case sendCoinError

   case coinInputSuccess(String, Bool)
   case reasonInputSuccess(String, Bool)

   case presentImagePicker
   case presentPickedImage(UIImage)
   case setHideAddPhotoButton(Bool)

   case sendButtonPressed
}

final class TransactScene<Asset: AssetProtocol>: DoubleStacksModel, Assetable, Scenarible2, Eventable {
   typealias Events = TransactEvents
   typealias State = StackState

   var events: [Int: LambdaProtocol?] = [:]

   private lazy var works = TransactWorks<Asset>()

   lazy var scenario: Scenario = TransactScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: TransactScenarioEvents(
         userSearchTXTFLDBeginEditing: viewModels.userSearchTextField.onEvent(\.didBeginEditing),
         userSearchTFDidEditingChanged: viewModels.userSearchTextField.onEvent(\.didEditingChanged),
         userSelected: viewModels.foundUsersList.onEvent(\.didSelectRow),
         sendButtonEvent: viewModels.sendButton.onEvent(\.didTap),
         transactInputChanged: viewModels.amountInputModel.textField.onEvent(\.didEditingChanged),
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged),
         anonymousSetOff: viewModels.options.anonimParamModel.switcher.onEvent(\.turnedOff),
         anonymousSetOn: viewModels.options.anonimParamModel.switcher.onEvent(\.turnedOn)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: ImagePickingScenarioEvents(
         startImagePicking: viewModels.addPhotoButton.onEvent(\.didTap),
         addImageToBasket: imagePicker.onEvent(\.didImagePicked),
         removeImageFromBasket: viewModels.pickedImages.on(\.didCloseImage),
         didMaximumReach: viewModels.pickedImages.on(\.didMaximumReached)
      )
   )

   private lazy var viewModels = TransactViewModels<Design>()

   private lazy var viewModelsWrapper = ScrollViewModelY()
      .set(.spacing(Grid.x16.value))
      .set(.models([
         viewModels.balanceInfo,
         viewModels.foundUsersList,
         viewModels.amountInputModel,
         viewModels.reasonTextView,
         viewModels.pickedImages.lefted(),
         viewModels.addPhotoButton,
         viewModels.options
      ]))

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorInfoBlock = CommonErrorBlock<Design>()

   private lazy var imagePicker = ImagePickerViewModel()

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

      viewModels.closeButton.onEvent(\.didTap) { [weak self] in
         self?.send(\.cancelled)
      }

      view.onEvent(\.willAppear) { [weak self] in
         self?.viewModels.foundUsersList.set(.items([]))
         self?.scenario2.start()
         self?.scenario.start()
         self?.setToInitialCondition()
      }
   }

   func configure() {
      let shadow = Shadow(radius: 50, offset: .zero, color: Design.color.iconContrast, opacity: 0.33)
      topStackModel
         .safeAreaOffsetDisabled()
         .axis(.vertical)
         .distribution(.fill)
         .alignment(.fill)
         .backColor(Design.color.background)
         .padding(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
         .cornerRadius(Design.params.cornerRadiusMedium)
         .shadow(shadow)
         .arrangedModels([
            //
            Wrapped3X(
               Spacer(50),
               LabelModel()
                  .alignment(.center)
                  .set(Design.state.label.body3)
                  .text(Design.Text.title.newTransact),
               viewModels.closeButton
            )
            .height(64)
            .alignment(.center)
            .distribution(.equalCentering),
            //
            viewModels.userSearchTextField,
            Grid.x8.spacer,

            viewModels.notFoundBlock.hidden(true),
            errorInfoBlock.hidden(true),
            activityIndicator.hidden(false),

            viewModelsWrapper,
            Spacer(16)
         ])
         .disableBottomRadius(Design.params.cornerRadiusMedium)

      bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .arrangedModels([
            viewModels.sendButton
         ])
   }

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
      viewModels.reasonTextView.text("")
   }
}

extension TransactScene: StateMachine {
   func setState(_ state: TransactState) {
      debug(state)

      switch state {
      case .initial:
         activityIndicator.hidden(false)
      //
      case .loadProfilError:
         activityIndicator.hidden(true)
      //
      case .loadTransactionsError:
         activityIndicator.hidden(true)
      //
      case .loadTokensSuccess:
         activityIndicator.hidden(false)

      case .loadTokensError:
         viewModels.userSearchTextField.hidden(true)
         activityIndicator.hidden(true)
      //
      case .loadBalanceSuccess(let balance):
         viewModels.balanceInfo.models.down.label.text(String(balance))
      //
      case .loadBalanceError:
         activityIndicator.hidden(true)
      //
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
         activityIndicator.hidden(true)
      //
      case .loadUsersListError:
         viewModels.foundUsersList.hidden(true)
         activityIndicator.hidden(true)
         presentFoundUsers(users: [])
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
         errorInfoBlock.hidden(false)
      //
      case .coinInputSuccess(let text, let isCorrect):
         viewModels.amountInputModel.textField.set(.text(text))
         if isCorrect {
            viewModels.amountInputModel.setState(.normal(text))
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.amountInputModel.setState(.noInput)
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
         view.removeFromSuperview()
      //
      case .presentImagePicker:
         guard let baseVC = vcModel else { return }
         imagePicker.sendEvent(\.presentOn, baseVC)
      }
   }
}

private extension TransactScene {
   func applySelectUserMode() {
      viewModels.pickedImages.hidden(true)
      viewModels.balanceInfo.set(.hidden(true))
      viewModels.amountInputModel.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
      viewModels.options.hidden(true)
      viewModels.addPhotoButton.hidden(true)
      bottomStackModel.hidden(true)
      viewModels.notFoundBlock.hidden(true)
      viewModels.userSearchTextField.hidden(false)
   }

   func presentBalanceInfo() {
      viewModels.notFoundBlock.hidden(true)
      viewModels.balanceInfo.set(.hidden(false))
   }

   func applyReadyToSendMode() {
      viewModels.pickedImages.hidden(false)
      viewModels.amountInputModel.set(.hidden(false))
      viewModels.reasonTextView.set(.hidden(false))
      viewModels.options.hidden(false)
      viewModels.addPhotoButton.hidden(false)
      bottomStackModel.hidden(false)
   }
}

private extension TransactScene {
   func presentFoundUsers(users: [FoundUser]) {
      viewModels.foundUsersList.set(.items(users))
      viewModels.foundUsersList.hiddenAnimated(users.isEmpty ? true : false, duration: 0.5)

      viewModels.notFoundBlock.hiddenAnimated(!users.isEmpty, duration: 0.5)
   }
}
