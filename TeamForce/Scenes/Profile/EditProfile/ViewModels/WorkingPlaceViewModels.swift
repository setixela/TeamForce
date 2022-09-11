//
//  WorkingPlaceViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.09.2022.
//

import ReactiveWorks

final class WorkingPlaceViewModels<Design: DSP>: BaseModel, Designable {
   lazy var companyTitleBody = Design.model.profile.titleBody
      .setAll {
         $0.text("Компания")
         $1.text("Компания")
      }

   lazy var departmentTitleBody = Design.model.profile.titleBody
      .setAll {
         $0.text("Подразделение")
         $1.text("Подразделение")
      }

   lazy var startWorkTitleBody = Design.model.profile.titleBody
      .setAll {
         $0.text("Дата начала работы")
         $1.text("Дата начала работы")
      }
}

extension WorkingPlaceViewModels: SetupProtocol {
   func setup(_ params: UserData) {
      companyTitleBody.setAll {
         $1.text(params.profile.organization)
      }
      departmentTitleBody.setAll {
         $1.text(params.profile.department)
      }
      startWorkTitleBody.setAll {
         $1.text(params.profile.hiredAt.string)
      }
   }
}
