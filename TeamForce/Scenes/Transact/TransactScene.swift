//
//  TransactModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 29.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactEvents: InitProtocol {
   var cancelled: Event<Void>?
   var finishWithSuccess: Event<StatusViewInput>?
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

   case presentPickedImage(UIImage)
   case setHideAddPhotoButton(Bool)

   case startActivityIndicator
}

final class TransactScene<Asset: AssetProtocol>: DoubleStacksModel, Assetable, Scenarible2, Communicable {
   typealias State = StackState

   var events = TransactEvents()

   private lazy var works = TransactWorks<Asset>()

   lazy var scenario: Scenario = TransactScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: TransactScenarioEvents(
         userSearchTXTFLDBeginEditing: viewModels.userSearchTextField.onEvent(\.didBeginEditing),
         userSearchTFDidEditingChanged: viewModels.userSearchTextField.onEvent(\.didEditingChanged),
         userSelected: viewModels.foundUsersList.onEvent(\.didSelectRow),
         sendButtonEvent: viewModels.sendButton.onEvent(\.didTap),
         transactInputChanged: viewModels.transactInputViewModel.textField.onEvent(\.didEditingChanged),
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged),
         anonymousSetOff: options.anonimParamModel.switcher.onEvent(\.turnedOff),
         anonymousSetOn: options.anonimParamModel.switcher.onEvent(\.turnedOn)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: ImagePickingScenarioEvents(
         addImageToBasket: imagePicker.onEvent(\.didImagePicked),
         removeImageFromBasket: pickedImages.onEvent(\.didCloseImage),
         didMaximumReach: pickedImages.onEvent(\.didMaximumReached)
      )
   )

   private lazy var viewModels = TransactViewModels<Design>()

   private lazy var pickedImages = PickedImagePanel<Design>()

   private lazy var closeButton = ButtonModel()
      .set_title(Design.Text.title.close)
      .set_textColor(Design.color.textBrand)

   private lazy var options = TransactOptionsVM<Design>()
   private lazy var viewModelsWrapper = ScrollViewModelY()
      .set(.spacing(Grid.x16.value))
      .set(.models([
         viewModels.balanceInfo,
         viewModels.foundUsersList,
         viewModels.transactInputViewModel,
         viewModels.reasonTextView,
         pickedImages.lefted(),
         viewModels.addPhotoButton,
         options
      ]))

   private lazy var notFoundBlock = Wrapped2Y(
      ImageViewModel()
         .set_image(Design.icon.userNotFound)
         .set_size(.square(275)),
      Design.label.body1
         .set_numberOfLines(0)
         .set_alignment(.center)
         .set_text(Design.Text.title.userNotFound)
   )

   private lazy var activityIndicator = ActivityIndicator<Design>()

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

      closeButton.onEvent(\.didTap) { [weak self] in
         self?.sendEvent(\.cancelled)
         self?.viewModels.foundUsersList.set(.items([]))
         self?.view.removeFromSuperview()
      }

      view.onEvent(\.willAppear) { [weak self] in

         self?.scenario.start()
         self?.scenario2.start()
      }

      viewModels.addPhotoButton
         .onEvent(\.didTap) { [weak self] in
            guard let baseVC = self?.vcModel else { return }

            self?.imagePicker.sendEvent(\.presentOn, baseVC)
         }

      setToInitialCondition()
   }

   func configure() {
      topStackModel
         .set_safeAreaOffsetDisabled()
         .set_axis(.vertical)
         .set_distribution(.fill)
         .set_alignment(.fill)
         .set_backColor(Design.color.background)
         .set_padding(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
         .set_cornerRadius(Design.params.cornerRadiusMedium)
         .set_arrangedModels([
            //
            Wrapped3X(
               Spacer(50),
               LabelModel()
                  .set_alignment(.center)
                  .set(Design.state.label.body3)
                  .set_text(Design.Text.title.newTransact),
               closeButton
            )
            .set_height(64)
            .set_alignment(.center)
            .set_distribution(.equalCentering),
            //
            viewModels.userSearchTextField,
            Grid.x8.spacer,

            notFoundBlock.set_hidden(true),
            activityIndicator.set_hidden(false),

            viewModelsWrapper
         ])

      bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            viewModels.sendButton
         ])
   }

   private func setToInitialCondition() {
      clearFields()
      scenario.start()

      viewModels.sendButton.set(Design.state.button.inactive)
      viewModels.transactInputViewModel.setState(.noInput)

      currentState = .initial
      setState(.initial)
      applySelectUserMode()
   }

   private func clearFields() {
      viewModels.userSearchTextField.set_text("")
      viewModels.transactInputViewModel.textField.set_text("")
      viewModels.reasonTextView.set_text("")
   }
}

extension TransactScene: StateMachine {
   func setState(_ state: TransactState) {
      debug(state)

      switch state {
      case .initial:
         activityIndicator.set_hidden(false)
      //
      case .loadProfilError:
         activityIndicator.set_hidden(true)
      //
      case .loadTransactionsError:
         activityIndicator.set_hidden(true)
      //
      case .loadTokensSuccess:
         activityIndicator.set_hidden(false)

      case .loadTokensError:
         viewModels.userSearchTextField.set_hidden(true)
         activityIndicator.set_hidden(true)
      //
      case .loadBalanceSuccess(let balance):
         viewModels.balanceInfo.models.down.label.set_text(String(balance))
      //
      case .loadBalanceError:
         activityIndicator.set_hidden(true)
      //
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
         activityIndicator.set_hidden(true)
      //
      case .loadUsersListError:
         viewModels.foundUsersList.set_hidden(true)
         activityIndicator.set_hidden(true)
         presentFoundUsers(users: [])
      //
      case .presentFoundUser(let users):
         viewModels.foundUsersList.set_hidden(true)
         activityIndicator.set_hidden(true)
         presentFoundUsers(users: users)

      //
      case .presentUsers(let users):
         viewModels.foundUsersList.set_hidden(true)
         activityIndicator.set_hidden(true)
         presentFoundUsers(users: users)
      //
      case .listOfFoundUsers(let users):
         activityIndicator.set_hidden(true)
         presentFoundUsers(users: users)
      //
      case .userSelectedSuccess(_, let index):
         viewModels.userSearchTextField.set_hidden(true)

         if case .userSelectedSuccess = currentState {
            viewModels.userSearchTextField.set_hidden(false)
            viewModels.foundUsersList.set_hidden(true)
            currentState = .initial
            applySelectUserMode()
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
         activityIndicator.set_hidden(false)
         viewModels.foundUsersList.set(.items([]))
         applySelectUserMode()
      //
      case .sendCoinSuccess(let tuple):

         let sended = StatusViewInput(sendCoinInfo: tuple.1,
                                      username: tuple.0,
                                      foundUser: viewModels.foundUsersList.items.first as! FoundUser)
         sendEvent(\.finishWithSuccess, sended)
         setToInitialCondition()
         view.removeFromSuperview()
      //
      case .sendCoinError:
         presentAlert(text: "Не могу послать деньгу")
      //
      case .coinInputSuccess(let text, let isCorrect):
         viewModels.transactInputViewModel.textField.set(.text(text))
         if isCorrect {
            viewModels.transactInputViewModel.setState(.normal(text))
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.transactInputViewModel.setState(.noInput)
            viewModels.transactInputViewModel.textField.set(.text(text))
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
      case .presentPickedImage(let image):
         pickedImages.addButton(image: image)
      case .setHideAddPhotoButton(let value):
         viewModels.addPhotoButton.set_hidden(value)
      case .startActivityIndicator:
         break
      }
   }
}

private extension TransactScene {
   func applySelectUserMode() {
      pickedImages.set_hidden(true)
      viewModels.balanceInfo.set(.hidden(true))
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
      options.set_hidden(true)
      viewModels.addPhotoButton.set_hidden(true)
      bottomStackModel.set_hidden(true)
      notFoundBlock.set_hidden(true)
      viewModels.userSearchTextField.set_hidden(false)
   }

   func presentBalanceInfo() {
      notFoundBlock.set_hidden(true)
      viewModels.balanceInfo.set(.hidden(false))
   }

   func applyReadyToSendMode() {
      pickedImages.set_hidden(false)
      viewModels.transactInputViewModel.set(.hidden(false))
      viewModels.reasonTextView.set(.hidden(false))
      options.set_hidden(false)
      viewModels.addPhotoButton.set_hidden(false)
      bottomStackModel.set_hidden(false)
   }
}

private extension TransactScene {
   func presentFoundUsers(users: [FoundUser]) {
      viewModels.foundUsersList.set(.items(users))
      viewModels.foundUsersList.set(.hidden(users.isEmpty ? true : false))

      if users.isEmpty {
         notFoundBlock.set_alpha(0)
         notFoundBlock.set_hidden(false)
         UIView.animate(withDuration: 0.3) {
            self.notFoundBlock.set_alpha(1)
         }
      } else {
         notFoundBlock.set_hidden(true)
      }
   }

   func presentAlert(text: String) {}
}

extension UIView {
   func clearConstraints() {
      for subview in subviews {
         subview.clearConstraints()
      }
      removeConstraints(constraints)
   }
}

class ImageLabelLabelMRD: Combos<SComboMRD<ImageViewModel, LabelModel, LabelModel>> {}

struct PickedImagePanelEvents: InitProtocol {
   var didCloseImage: Event<UIImage>?
   var didMaximumReached: Event<Void>?
}

final class PickedImagePanel<Design: DSP>: StackModel, Designable, Communicable {
   var events = PickedImagePanelEvents()

   private var picked = [UIImage: UIViewModel]()

   private let maxCount = 1

   override func start() {
      set_axis(.horizontal)
      set_alignment(.leading)
      set_distribution(.equalSpacing)
      set_spacing(8)
   }

   func addButton(image: UIImage) {
      guard picked.count < maxCount else { return }

      let pickedImage = PickedImage<Design>()
      picked[image] = pickedImage
      pickedImage.image.set_image(image)

      set_arrangedModels(Array(picked.values))

      pickedImage.closeButton.onEvent(\.didTap) { [weak self] in
         guard let self = self else { return }

         self.sendEvent(\.didCloseImage, image)
         let model = self.picked[image]
         model?.uiView.removeFromSuperview()
         self.picked[image] = nil
      }

      if picked.count >= maxCount {
         sendEvent(\.didMaximumReached)
      }
   }
}

final class PickedImage<Design: DSP>: StackModel, Designable {
   let closeButton = ButtonModel()
      .set_image(Design.icon.cross.withTintColor(.white))
      .set_size(.square(23))

   let image = ImageViewModel()
      .set_size(.square(Grid.x80.value))
      .set_cornerRadius(Design.params.cornerRadius)

   override func start() {
      super.start()
      set_backColor(Design.color.background)
      set_axis(.horizontal)
      set_alignment(.top)
      set_size(.square(Grid.x80.value))
      set_cornerRadius(Design.params.cornerRadius)
      set_arrangedModels([
         Grid.xxx.spacer,
         closeButton
      ])
      set_backViewModel(image)
   }
}
