//
//  ReadyWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import Foundation
// This file is to save ready works of new apiworkers

// 1. CurrentPeriod
//lazy var getCurrentPeriod = Work<Void, Period>() { [weak self] work in
//   self?.useCase.getCurrentPeriod.work
//      .retainBy(self?.retainer)
//      .doAsync()
//      .onSuccess {
//         print("I am current period \($0)")
//      }
//      .onFail {
//         print("Failed to get current period")
//      }
//}

// 2. PeriodByDate
//lazy var getPeriodByDate = Work<String, Period>() { [weak self] work in
//   self?.useCase.getPeriodByDate.work
//      .retainBy(self?.retainer)
//      .doAsync(work.input)
//      .onSuccess {
//         print("I am period by date \($0)")
//      }
//      .onFail {
//         print("I am failed to load period by date")
//      }
//}

//3. GetPeriodsFromDate
//lazy var getPeriodsFromDate = Work<String, [Period]>() { [weak self] work in
//self?.useCase.getPeriodsFromDate.work
//   .retainBy(self?.retainer)
//   .doAsync(work.input)
//   .onSuccess {
//      print("I am success \($0)")
//   }
//   .onFail {
//      print("I am failed")
//   }
//}

// 4. UpdateProfileImage
//lazy var updateProfileImage = Work<(Int, UIImage), Void> { [weak self] work in
//   self?.useCase.updateProfileImage.work
//      .retainBy(self?.retainer)
//      .doAsync(work.input)
//      .onSuccess {
//         print("I am success update image")
//      }
//      .onFail {
//         print("I am failed to update image")
//      }
//}
