//
//  CommonModelBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import Foundation
import ReactiveWorks

protocol CommonModelBuilder: InitProtocol, Designable {
   var activityIndicator: ActivityIndicator<Design> { get }
   
   var connectionErrorBlock: CommonErrorBlock<Design> { get }
   var systemErrorBlock: SystemErrorBlockVM<Design> { get }

   var imagePicker: ImagePickerViewModel { get }

   var bottomPopupPresenter: BottomPopupPresenter { get }

   var divider: WrappedX<ViewModel> { get }
}

struct CommonBuilder<Design: DSP>: CommonModelBuilder {
   var activityIndicator: ActivityIndicator<Design> { .init() }

   var connectionErrorBlock: CommonErrorBlock<Design> { .init() }
   var systemErrorBlock: SystemErrorBlockVM<Design> { .init()  }

   var imagePicker: ImagePickerViewModel { .init() }

   var bottomPopupPresenter: BottomPopupPresenter { .init() }

   var divider: WrappedX<ViewModel> {
      .init()
      .alignment(.center)
      .height(Grid.x64.value)
      .padding(.sideOffset(-Design.params.commonSideOffset))
      .arrangedModels([
         ViewModel()
            .height(Grid.x4.value)
            .backColor(Design.color.iconMidpointSecondary)
      ])
   }
}
