//
//  ModelBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import Foundation

struct ModelBuilder<Design: DSP>: ModelBuilderProtocol {
   typealias Transact = TransactBuilder<Design>
   typealias Common = CommonBuilder<Design>
}
