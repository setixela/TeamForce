//
//  File.swift
//
//
//  Created by Aleksandr Solovyev on 09.08.2022.
//

import ReactiveWorks

protocol SCP: InitProtocol {}

// right

struct SComboM<M: VMP>: SCP {
   init(main: M) {
      self.main = main
   }

   init() {}

   var main: M = .init()
}

struct SComboMR<M: VMP, R: VMP>: SCP {
   init(main: M, right: R) {
      self.main = main
      self.right = right
   }

   init() {}

   var main: M = .init()
   var right: R = .init()

   // M>R
}

struct SComboMRR<M: VMP, R: VMP, R2: VMP>: SCP {
   init(main: M, right: R, right2: R2) {
      self.main = main
      self.right = right
      self.right2 = right2
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var right2: R2 = .init()

   // M>R>R
}

struct SComboMRRR<M: VMP, R: VMP, R2: VMP, R3: VMP>: SCP {
   init(main: M, right: R, right2: R2, right3: R3) {
      self.main = main
      self.right = right
      self.right2 = right2
      self.right3 = right3
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var right2: R2 = .init()
   var right3: R3 = .init()

   // M>R>R>R
}

struct SComboMRD<M: VMP, R: VMP, D: VMP>: SCP {
   init(main: M, right: R, down: D) {
      self.main = main
      self.right = right
      self.down = down
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var down: D = .init()
}

struct SComboMRRD<M: VMP, R: VMP, R2: VMP, D: VMP>: SCP {
   init(main: M, right: R, right2: R2, down: D) {
      self.main = main
      self.right = right
      self.right2 = right2
      self.down = down
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var right2: R2 = .init()
   var down: D = .init()
}

struct SComboMRDR<M: VMP, R: VMP, D: VMP, R2: VMP>: SCP {
   init(main: M, right: R, down: D, right2: R2) {
      self.main = main
      self.right = right
      self.down = down
      self.right2 = right2
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var down: D = .init()
   var right2: R2 = .init()
}

struct SComboMRDD<M: VMP, R: VMP, D: VMP, D2: VMP>: SCP {
   init(main: M, right: R, down: D, down2: D2) {
      self.main = main
      self.right = right
      self.down = down
      self.down2 = down2
   }

   init() {}

   var main: M = .init()
   var right: R = .init()
   var down: D = .init()
   var down2: D2 = .init()
}

// down

struct SComboMD<M: VMP, D: VMP>: SCP {
   init(main: M, down: D) {
      self.main = main
      self.down = down
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
}

struct SComboMDR<M: VMP, D: VMP, R: VMP>: SCP {
   init(main: M, down: D, right: R) {
      self.main = main
      self.down = down
      self.right = right
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var right: R = .init()
}

struct SComboMDD<M: VMP, D: VMP, D2: VMP>: SCP {
   init(main: M, down: D, down2: D2) {
      self.main = main
      self.down = down
      self.down2 = down2
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var down2: D2 = .init()
}

struct SComboMDDR<M: VMP, D: VMP, D2: VMP, R: VMP>: SCP {
   init(main: M, down: D, down2: D2, right: R) {
      self.main = main
      self.down = down
      self.down2 = down2
      self.right = right
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var down2: D2 = .init()
   var right: R = .init()
}

struct SComboMDRD<M: VMP, D: VMP, R: VMP, D2: VMP>: SCP {
   init(main: M, down: D, right: R, down2: D2) {
      self.main = main
      self.down = down
      self.right = right
      self.down2 = down2
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var right: R = .init()
   var down2: D2 = .init()
}

struct SComboMDRR<M: VMP, D: VMP, R: VMP, R2: VMP>: SCP {
   init(main: M, down: D, right: R, right2: R2) {
      self.main = main
      self.down = down
      self.right = right
      self.right2 = right2
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var right: R = .init()
   var right2: R2 = .init()
}

struct SComboMDDD<M: VMP, D: VMP, D2: VMP, D3: VMP>: SCP {
   init(main: M, down: D, down2: D2, down3: D3) {
      self.main = main
      self.down = down
      self.down2 = down2
      self.down3 = down3
   }

   init() {}

   var main: M = .init()
   var down: D = .init()
   var down2: D2 = .init()
   var down3: D3 = .init()
}
