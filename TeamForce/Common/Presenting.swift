//
//  Presenting.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

protocol PresenterProtocol {
   var cellType: String { get }

   func viewModel(for input: Any) -> UIViewModel
}

final class Presenter<In, Out: UIViewModel>: Work<In, Out>, PresenterProtocol {
   func viewModel(for input: Any) -> UIViewModel {
      doSync(input as? In)
   }

   var cellType: String {
      let name = String(describing: In.self)
      return name
   }
}
