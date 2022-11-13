//
//  ChallengeCreateScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import UIKit

struct ChallengeCreateEvents: InitProtocol {
   var cancelled: Void?
   var continueButtonPressed: Void?
   var finishWithSuccess: Void?
   var finishWithError: Void?
}

enum ChallengeCreateSceneState {
   case initial
   case dismissScene
   case cancelButtonPressed
   case setReady(Bool)
   case updateDateButton(Date)

   case challengeCreated
}

final class ChallengeCreateScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Void
>, Scenarible2 {
   private lazy var works = ChallengeCreateWorks<Asset>()

   lazy var scenario: Scenario = ChallengeCreateScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate,
      events: ChallengeCreateScenarioEvents(
         didTitleInputChanged: titleInput.on(\.didEditingChanged),
         didDescriptionInputChanged: descriptionInput.on(\.didEditingChanged),
         didPrizeFundChanged: prizeFundInput.models.main.on(\.didEditingChanged),
         didDatePicked: datePicker.on(\.didDatePicked),
         didSendPressed: sendButton.on(\.didTap)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate2,
      events: ImagePickingScenarioEvents(
         startImagePicking: addPhotoButton.on(\.didTap),
         addImageToBasket: imagePicker.on(\.didImagePicked),
         removeImageFromBasket: photosPanel.on(\.didCloseImage),
         didMaximumReach: photosPanel.on(\.didMaximumReached)
      )
   )

   private lazy var infoBlock = TitleBodyY()
      .setAll { title, body in
         title
            .set(Design.state.label.body1)
            .text("Основная информация")
         body
            .set(Design.state.label.body2Secondary)
            .text("Заполните данные о челлендже")
      }
      .alignment(.center)
      .spacing(4)

   private lazy var titleInput = Design.model.transact.userSearchTextField
      .placeholder("Название")
      .placeholderColor(Design.color.textFieldPlaceholder)
   private lazy var descriptionInput = Design.model.transact.reasonInputTextView
      .placeholder("Описание")
      .placeholderColor(Design.color.textFieldPlaceholder)

   private lazy var finishDateButton = LabelIconX<Design>(Design.state.stack.buttonFrame)
      .set {
         $0.label
            .text("Дата завершения события")
            .set(Design.state.label.body2Secondary)
         $0.iconModel
            .image(Design.icon.calendarLine)
            .imageTintColor(Design.color.iconSecondary)
      }

   private lazy var datePicker = DatePickerModel()
   private lazy var datePickWrapper = WrappedX(datePicker)
      .borderWidth(1)
      .borderColor(Design.color.iconSecondary)
      .cornerRadius(Design.params.cornerRadius)
      .hidden(true)

   private lazy var prizeFundInput = M<TextFieldModel>.R<Spacer>.R2<ImageViewModel>.Combo()
      .setAll { input, _, icon in
         input
            .set(Design.state.textField.invisible)
            .set(.placeholder("Укажите призовой фонд"))
            .placeholderColor(Design.color.textFieldPlaceholder)
            .clearButtonMode(.never)
            .onlyDigitsMode()
            .keyboardType(.numberPad)
         icon
            .size(.square(24))
            .image(Design.icon.strangeLogo)
            .imageTintColor(Design.color.iconSecondary)
      }
      .cornerRadius(Design.params.cornerRadiusSmall)
      .borderColor(Design.color.iconMidpoint)
      .borderWidth(1)
      .height(Design.params.buttonHeight)
      .padding(.horizontalOffset(16))

   private lazy var prizePlacesInput = TextFieldModel()
      .set(Design.state.textField.default)
      .placeholder("Укажите количество призовых мест")
      .onlyDigitsMode()
      .hidden(true)

   private lazy var photosPanel = Design.model.transact.pickedImagesPanel.hidden(true)
   private lazy var addPhotoButton = Design.model.transact.addPhotoButton
      .title("Обложка челленджа")

   private lazy var sendButton = Design.model.transact.sendButton
      .set(Design.state.button.inactive)
      .title("Создать")
   private lazy var cancelButton = Design.button.transparent
      .title("Отменить")

   private lazy var activityIndicator = Design.model.common.activityIndicator
   private lazy var imagePicker = Design.model.common.imagePicker

   private var currentState = ChallengeCreateSceneState.initial

   // MARK: - Start

   override func start() {
      super.start()
      mainVM.bodyStack
         .arrangedModels([
            ActivityIndicator<Design>()
         ])

      vcModel?.on(\.viewDidLoad, self) {
         $0.mainVM.bodyStack
            .arrangedModels([
               ScrollViewModelY()
                  .set(.spacing(16))
                  .set(.arrangedModels([
                     $0.infoBlock,
                     $0.titleInput,
                     $0.descriptionInput,
                     $0.finishDateButton,
                     $0.datePickWrapper,
                     $0.prizeFundInput,
                     $0.prizePlacesInput,
                     $0.photosPanel.lefted(),
                     $0.addPhotoButton,
                     Grid.x64.spacer
                  ]))
            ])

         $0.mainVM.footerStack
            .arrangedModels([
               $0.sendButton
               // cancelButton
            ])

         $0.mainVM.closeButton.on(\.didTap, $0) {
            $0.setState(.cancelButtonPressed)
         }

         $0.datePicker.view.minimumDate = Date()
         $0.finishDateButton.on(\.didTap, $0) {
            $0.toggleDatePickerHidden()
         }

         $0.scenario.start()
         $0.scenario2.start()
      }
   }
}

extension ChallengeCreateScene {
   func setState(_ state: ChallengeCreateSceneState) {
      switch state {
      case .initial:
         break
      case .dismissScene:
         dismiss()
      case .setReady(let isReady):
         if isReady {
            sendButton.set(Design.state.button.default)
            prizePlacesInput.hiddenAnimated(false, duration: 0.25)
         } else {
            sendButton.set(Design.state.button.inactive)
         }
      case .updateDateButton(let date):
         let text = date.convertToString(.medium)
         finishDateButton.label.text(text)
         toggleDatePickerHidden()
      case .cancelButtonPressed:
         dismiss()
         finishCanceled()
      case .challengeCreated:
         finishSucces()
      }
   }
}

extension ChallengeCreateScene {
   private func toggleDatePickerHidden() {
      vcModel?.hideKeyboard()
      datePickWrapper.hiddenAnimated(!datePickWrapper.view.isHidden,
                                     duration: 0.25)
   }
}

extension ChallengeCreateScene: StateMachine2 {
   func setState2(_ state: ImagePickingState) {
      switch state {
      //
      case .presentPickedImage(let image):
         photosPanel.addButton(image: image)
      //
      case .presentImagePicker:
         guard let baseVC = vcModel else { return }
         imagePicker.send(\.presentOn, baseVC)
      //
      case .setHideAddPhotoButton(let value):
         photosPanel.hiddenAnimated(!value, duration: 0.2)
         addPhotoButton.hiddenAnimated(value, duration: 0.2)
         //
      }
   }
}

struct DatePickerEvents: InitProtocol {
   var didDatePicked: Date?
}

class DatePickerModel: BaseViewModel<UIDatePicker> {
   var events: EventsStore = .init()

   override func start() {
      if #available(iOS 13.4, *) {
         view.preferredDatePickerStyle = .wheels
         view.overrideUserInterfaceStyle = .light
      } else {
         // Fallback on earlier versions
      }
      view.datePickerMode = .date
      view.addTarget(self, action: #selector(didDatePicked), for: .valueChanged)
   }

   @objc private func didDatePicked() {
      send(\.didDatePicked, view.date)
   }
}

extension DatePickerModel: Eventable {
   typealias Events = DatePickerEvents
}
