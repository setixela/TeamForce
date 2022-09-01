//
//  StorageUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.08.2022.
//

import ReactiveWorks

struct StorageWorks<Asset: AssetProtocol>: Assetable, WorkBasket {
   let retainer = Retainer()

   var loadToken: LoadTokenUseCase.WRK {
      LoadTokenUseCase(safeStringStorage: safeStringStorage)
         .retainedWork(retainer)
   }

   var loadCsrfToken: LoadCsrfTokenUseCase.WRK {
      LoadCsrfTokenUseCase(safeStringStorage: safeStringStorage)
         .retainedWork(retainer)
   }

   var loadBothTokens: LoadBothTokensUseCase.WRK {
      LoadBothTokensUseCase(safeStringStorage: safeStringStorage)
         .retainedWork(retainer)
   }
}

private extension StorageWorks {
   var safeStringStorage: StringStorageUseCase.WRK {
      StringStorageUseCase(storageEngine: Asset.service.safeStringStorage)
         .retainedWork(retainer)
   }
}
