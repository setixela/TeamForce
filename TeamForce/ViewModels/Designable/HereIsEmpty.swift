//
//  HereIsEmpty.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.10.2022.
//

import ReactiveWorks

final class HereIsEmpty<Design: DSP>: LabelModel, Designable {
   override func start() {
      super.start()

      alignment(.center)
      set(Design.state.label.body2Secondary)
      padding(.init(top: 24, left: 24, bottom: 24, right: 24))
      text("Здесь пока ничего нет")
   }
}

final class HereIsEmptySpacedBlock<Design: DSP>: M<HereIsEmpty<Design>>.D<Spacer>.Combo, Designable {
   required init() {
      super.init()

      setAll { _, _ in }
   }
}

