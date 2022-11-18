//
//  ChangeOrganizationVM.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 19.11.2022.
//

import ReactiveWorks

final class ChangeOrganizationVM<Design: DSP>: StackModel, Designable {
   //
   var events = EventsStore()
   //
   private lazy var changeButton = M<LabelModel>.D<LabelModel>.R<ImageViewModel>.Combo()
      .setAll { title, organization, icon in
         title
            .set(Design.state.label.caption)
            .text("Текущая организация")
            .textColor(Design.color.textBrand)
         organization
            .set(Design.state.label.body1)
            .padding(.top(8))
         icon
            .image(Design.icon.arrowDropDownLine)
            .imageTintColor(Design.color.iconBrand)
            .size(.square(32))
      }
      .padding(Design.params.cellContentPadding)
      .backColor(Design.color.backgroundBrandSecondary)
      .cornerRadius(Design.params.cornerRadius)

   private lazy var organizationsTable = TableItemsModel<Design>()
      .set(.presenters([organizationPresenter]))
      .cornerRadius(Design.params.cornerRadius)
      .borderWidth(1)
      .borderColor(Design.color.iconBrand)
      .hidden(true)

   override func start() {
      view.on(\.willAppear, self) {
         $0.configure()
      }
   }

   private func configure() {
      arrangedModels(
         changeButton,
         Spacer(8),
         organizationsTable
      )

      changeButton.view.startTapGestureRecognize()
      changeButton.view.on(\.didTap, self) {
         $0.organizationsTable.hidden(!$0.organizationsTable.view.isHidden)
      }

      organizationsTable.on(\.didSelectRowInt, self) {
         $0.send(\.didSelectOrganizationIndex, $1)
      }
   }

   private var organizationPresenter: Presenter<Organization, StackModel> { .init { work in
      let organization = work.unsafeInput

      let label = LabelModel()
         .text(organization.item.name ?? "")
         .textColor(Design.color.text)
      let icon = ImageViewModel()
         .contentMode(.scaleAspectFill)
         .image(Design.icon.anonAvatar)
         .size(.square(Grid.x36.value))
         .cornerRadius(Grid.x36.value / 2)

      let cell = StackModel()
         .spacing(Grid.x12.value)
         .axis(.horizontal)
         .alignment(.center)
         .arrangedModels([
            icon,
            label,
            Spacer(),
         ])
         .padding(.init(top: 12, left: 16, bottom: 12, right: 16))

      work.success(cell)
   }}
}

extension ChangeOrganizationVM: SetupProtocol {
   func setup(_ data: (currentOrg: String, orgs: [Organization])) {
      changeButton.models.down.text(data.currentOrg)
      organizationsTable.set(.items(data.orgs))
   }
}

extension ChangeOrganizationVM: Eventable {
   struct Events: InitProtocol {
      var didSelectOrganizationIndex: Int?
   }
}
