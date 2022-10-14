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

final class ChallengeCreateScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Void
>, Scenarible {
   typealias State = StackState

   private lazy var works = ChallengeCreateWorks<Asset>()

   lazy var scenario: Scenario = ChallengeCreateScenario(
      works: works,
      stateDelegate: setState,
      events: ChallengeCreateScenarioEvents()
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

//   private lazy var viewModels = ChallengeCreateViewModel<Design>()

   private lazy var titleInput = Design.model.transact.userSearchTextField
      .placeholder("Название")
   private lazy var descriptionInput = Design.model.transact.reasonInputTextView
      .placeholder("Описание")
   private lazy var finishDateButton = LabelIconX<Design>(Design.state.stack.buttonFrame)
      .set {
         $0.label
            .text("Дата завершения события")
            .set(Design.state.label.body2Secondary)
         $0.iconModel
            .image(Design.icon.calendarLine)
            .imageTintColor(Design.color.iconSecondary)
      }

   private lazy var prizeFundInput = M<TextFieldModel>.R<Spacer>.R2<ImageViewModel>.Combo()
      .setAll { input, _, icon in
         input
            .set(Design.state.textField.invisible)
            .set(.placeholder("Укажите призовой фонд"))
            .clearButtonMode(.never)
            .onlyDigitsMode()
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

   private lazy var photosPanel = Design.model.transact.pickedImagesPanel.hidden(true)
   private lazy var addPhotoButton = Design.model.transact.addPhotoButton
      .title("Обложка челленджа")

   private lazy var activityIndicator = Design.model.common.activityIndicator
   private lazy var imagePicker = Design.model.common.imagePicker

   private var currentState = ChallengeCreateSceneState.initial

   // MARK: - Start

   override func start() {
      super.start()

      mainVM.bodyStack
         .arrangedModels([
            ScrollViewModelY()
               .set(.spacing(16))
               .set(.arrangedModels([
                  infoBlock,
                  titleInput,
                  descriptionInput,
                  finishDateButton,
                  prizeFundInput,
                  prizePlacesInput,
                  photosPanel,
                  addPhotoButton
               ])),
         ])

      mainVM.footerStack
         .arrangedModels([
            Grid.x1.spacer
         ])

      mainVM.closeButton.on(\.didTap, self) {
         $0.vcModel?.dismiss(animated: true)
      }

      scenario.start()
   }
}

enum ChallengeCreateSceneState {
   case initial

   case presentImagePicker
   case presentPickedImage(UIImage)
   case setHideAddPhotoButton(Bool)

   case continueButtonPressed
   case cancelButtonPressed
}

extension ChallengeCreateScene: StateMachine {
   func setState(_ state: ChallengeCreateSceneState) {}
}
