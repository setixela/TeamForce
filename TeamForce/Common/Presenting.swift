//
//  Presenting.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

protocol PresenterProtocol {
   var cellType: String { get }

   func viewModel(for item: Any, index: Int) -> UIViewModel
}

open class Presenter<In, Out: UIViewModel>: Work<(item: In, index: Int), Out>, PresenterProtocol {
   func viewModel(for item: Any, index: Int) -> UIViewModel {
      doSync((item: item, index: index) as? (In, Int)) ?? { fatalError() }()
   }

   var cellType: String {
      let name = String(describing: In.self)
      return name
   }
}
