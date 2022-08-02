//
//  NilChecker.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

final class NilBlocker<T>: WorkerProtocol {
   func doAsync(work: Work<T,T>) {
      guard let input = work.input else {
         work.fail(())
         return
      }

      work.success(result: input)
   }
}

