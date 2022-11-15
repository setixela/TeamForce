//
//  ChooseOrgScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

// MARK: - ChooseOrgScne

final class ChooseOrgScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   [OrganizationAuth]
> {
   //

   private lazy var useCase = Asset.apiUseCase
   
   lazy var organizationsTable = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         OrganizationPresenters<Design>.presenter,
         SpacerPresenter.presenter
      ]))

   // MARK: - Start

   override func start() {
      configure()
      guard let organizations = inputValue else { return }
      
      organizationsTable.set(.items(organizations + [SpacerItem(size: Grid.x64.value)]))
      
      organizationsTable
         .on(\.didSelectRowInt) { [weak self] in

            let org = organizations[$0]
            self?.useCase.chooseOrganization
               .doAsync(org)
               .onSuccess {
                  let authResult = AuthResult(xId: $0.xId,
                                              xCode: $0.xCode,
                                              account: $0.account,
                                              organizationId: String(org.organizationId))
                  print("success")
                  Asset.router?.route(.push, scene: \.verify, payload: authResult)
               }
               .onFail {
                  print("fail")
               }
         }
   }
}

// MARK: - Configure presenting

private extension ChooseOrgScene {
   func configure() {
      mainVM.header
         .text(Design.Text.title.autorisation)
      mainVM.bodyStack
         .arrangedModels([
            organizationsTable,
            Grid.xxx.spacer
         ])
   }
}

class OrganizationPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()
   
   static var presenter: Presenter<OrganizationAuth, WrappedX<StackModel>> {
      Presenter { work in
         let item = work.unsafeInput.item

         let icon = ImageViewModel()
            .contentMode(.scaleAspectFill)
            .image(Design.icon.newAvatar)
            .size(.square(Grid.x36.value))
            .cornerRadius(Grid.x36.value / 2)
         
         let orgName = LabelModel()
            .text(item.organizationName.string)
            .set(Design.state.label.body1)
         
         if let avatar = item.organizationPhoto {
            icon.url(TeamForceEndpoints.urlBase + avatar)
         } else {
            icon.image(Design.icon.anonAvatar)
         }
         
         let cellStack = WrappedX(
            StackModel()
               .padding(Design.params.cellContentPadding)
               .spacing(Grid.x12.value)
               .axis(.horizontal)
               .alignment(.center)
               .arrangedModels([
                  icon,
                  orgName
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
               .backColor(Design.color.backgroundInfoSecondary)
         )
         .padding(.outline(Grid.x2.value))
         
         work.success(result: cellStack)
      }
   }
}
