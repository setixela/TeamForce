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
   var imagePicker: ImagePickerViewModel { get }
}

struct CommonBuilder<Design: DSP>: CommonModelBuilder {
   var activityIndicator: ActivityIndicator<Design> { .init() }
   var connectionErrorBlock: CommonErrorBlock<Design> { .init() }
   var imagePicker: ImagePickerViewModel { .init() }
}
