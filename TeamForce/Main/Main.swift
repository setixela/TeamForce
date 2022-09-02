//
//  Main.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.09.2022.
//

import ReactiveWorks

struct Main<M: VMP>: InitProtocol {
   typealias Combo = Combos<SComboM<M>>

   enum Right<R: VMP> {
      typealias Combo = Combos<SComboMD<M, R>>

      enum Right2<R2: VMP> {
         typealias Combo = Combos<SComboMRR<M, R, R2>>

         enum Right3<R3: VMP> {
            typealias Combo = Combos<SComboMRRR<M, R, R2, R3>>
         }

         enum Down<D: VMP> {
            typealias Combo = Combos<SComboMRRD<M, R, R2, D>>
         }
      }

      enum Down<D: VMP> {
         typealias Combo = Combos<SComboMRD<M, R, D>>

         enum Right2<R2: VMP> {
            typealias Combo = Combos<SComboMRDR<M, R, D, R2>>
         }

         enum Down2<D2: VMP> {
            typealias Combo = Combos<SComboMRDD<M, R, D, D2>>
         }
      }
   }

   enum Down<D: VMP> {
      typealias Combo = Combos<SComboMD<M, D>>

      enum Right<R: VMP> {
         typealias Combo = Combos<SComboMDR<M, D, R>>

         enum Right2<R2: VMP> {
            typealias Combo = Combos<SComboMDRR<M, D, R, R2>>
         }

         enum Down2<D2: VMP> {
            typealias Combo = Combos<SComboMDRD<M, D, R, D2>>
         }
      }

      enum Down2<D2: VMP> {
         typealias Combo = Combos<SComboMDD<M, D, D2>>

         enum Right<R: VMP> {
            typealias Combo = Combos<SComboMDDR<M, D, D2, R>>
         }

         enum Down3<D3: VMP> {
            typealias Combo = Combos<SComboMDDD<M, D, D2, D3>>
         }
      }
   }
}
