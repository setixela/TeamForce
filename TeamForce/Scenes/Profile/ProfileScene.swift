//
//  ProfileScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.11.2022.
//

import ReactiveWorks

class ProfileScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   BrandDoubleStackVM<Asset.Design>,
   Asset,
   Int
>, Configurable {

   //
   var userData: UserData?
   //
   lazy var userModel = Design.model.profile.userEditPanel

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.caption2),
         email,
         phone,
      ])

   lazy var infoStackSecondary = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("МЕСТО РАБОТЫ")
            .set(Design.state.label.caption2),
         organization,
         department,
         hiredAt,
      ])

   // MARK: - Private

   private lazy var email = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Корпоративная почта")
         $1.text("-")
      }

   private lazy var phone = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Мобильный номер")
         $1.text("-")
      }

   private lazy var organization = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Компания")
         $1.text("-")
      }

   private lazy var department = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Подразделение")
         $1.text("-")
      }

   private lazy var hiredAt = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Дата начала работы")
         $1.text("-")
      }

   // MARK: - Services

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)
   private lazy var useCase = Asset.apiUseCase
   private var balance: Balance?

   private var userAvatar: String?

   override func start() {
      vcModel?
         .clearBackButton()
         .send(\.setTitle, "Профиль")
         .on(\.viewDidLoad, self) {
            $0.configureModels()
            $0.configure()
            $0.configureProfile()
         }
   }

   func configure() {
      mainVM.bodyStack.arrangedModels(
         userModel,
         Spacer(32),
         infoStack,
         Spacer(8),
         infoStackSecondary,
         Spacer(8),
         Grid.xxx.spacer
      )
   }

   private func configureModels() {
      mainVM.bodyStack
         .set(.backColor(Design.color.backgroundSecondary))
         .set(.axis(.vertical))
         .set(.distribution(.fill))
         .set(.alignment(.fill))
         .padTop(-32)

      userModel.models.main.view.on(\.didTap, self) {
         guard let userAvatarUrl = $0.userAvatar else { return }

         let fullUrl = TeamForceEndpoints.convertToFullImageUrl(userAvatarUrl)

         Asset.router?.route(.presentModally(.automatic), scene: \.imageViewer, payload: fullUrl)
      }
   }

   func configureProfile() {
      if let input = inputValue {
         print("input is \(input)")
         useCase.getProfileById
            .doAsync(input)
            .onSuccess { [weak self] userData in
               self?.setLabels(userData: userData)
               self?.userAvatar = userData.profile.photo
               self?.userData = userData
            }
            .onFail {
               print("failed to load profile")
            }
         userModel.models.right2.hidden(true)

      } else {
         safeStringStorageModel
            .doAsync("token")
            .onFail {
               print("token not found")
            }
            .doMap {
               TokenRequest(token: $0)
            }
            .doNext(worker: userProfileApiModel)
            .onSuccess { [weak self] userData in
               self?.userData = userData
               self?.setLabels(userData: userData)
               self?.userAvatar = userData.profile.photo
            }.onFail {
               print("load profile error")
            }
      }
   }

   private func clearLabels() {
      email.setAll {
         $1.text("-")
      }
      phone.setAll {
         $1.text("-")
      }
   }

   private func setLabels(userData: UserData) {
      clearLabels()
      let profile = userData.profile
      let fullName = profile.surName.string + " " +
         profile.firstName.string + " " + profile.middleName.string
      userModel.models.right.fullName.text(fullName)
      userModel.models.right.nickName.text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         userModel.models.main.url(TeamForceEndpoints.urlBase + urlSuffix)
      }

      // infoStackSecondary
      organization.setAll {
         $1.text(profile.organization)
      }
      department.setAll {
         $1.text(profile.department)
      }
      hiredAt.setAll {
         $1.text(profile.hiredAt.string)
      }

      // infoStack
      if let contacts = profile.contacts {
         for contact in contacts {
            switch contact.contactType {
            case "@":
               email.setAll {
                  $1.text(contact.contactId)
               }
            case "P":
               phone.setAll {
                  $1.text(contact.contactId)
               }
            case "T":
               userModel.models.right.nickName.text("@" + contact.contactId)
            default:
               print("Contact error")
            }
         }
      }
   }
}

final class SettingsTitleBodyDT<Design: DSP>: TitleSubtitleY<Design> {
   required init() {
      super.init()
      spacing(4)
      setAll { main, down in
         main
            .alignment(.left)
            .set(Design.state.label.caption)
            .textColor(Design.color.textSecondary)
         down
            .alignment(.left)
            .set(Design.state.label.default)
            .textColor(Design.color.text)
      }
   }
}

final class UserProfileStack<Design: DSP>: StackModel, Designable {
   override func start() {
      super.start()

      backColor(Design.color.backgroundInfoSecondary)
      padding(.init(top: 16, left: 16, bottom: 16, right: 16))
      cornerRadius(Design.params.cornerRadiusSmall)
      spacing(12)
      distribution(.equalSpacing)
      alignment(.leading)
   }
}

final class ProfileTitle<Design: DSP>: StackModel, Designable {
   override func start() {
      axis(.horizontal)
      spacing(8)
      arrangedModels(
         LabelModel()
            .set(Design.state.label.headline6Invert)
            .text("Профиль")
            .textColor(Design.color.textInvert),
         ImageViewModel()
            .size(.square(24))
            .image(Design.icon.tablerChevronDown)
            .imageTintColor(Design.color.iconInvert)
      )
   }
}
