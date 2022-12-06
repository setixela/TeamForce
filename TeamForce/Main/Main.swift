//
//  Main.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.09.2022.
//

import ReactiveWorks

typealias M = Main

struct Main<M: VMP>: InitProtocol {
   typealias Combo = Combos<SComboM<M>>
   typealias R = Right
   typealias D = Down

   enum Right<R: VMP> {
      typealias Combo = Combos<SComboMR<M, R>>
      typealias R2 = Right2
      typealias D = Down
      typealias LD = LeftDown

      enum Right2<R2: VMP> {
         typealias Combo = Combos<SComboMRR<M, R, R2>>
         typealias R3 = Right3
         typealias D = Down

         enum Right3<R3: VMP> {
            typealias Combo = Combos<SComboMRRR<M, R, R2, R3>>
         }

         enum Down<D: VMP> {
            typealias Combo = Combos<SComboMRRD<M, R, R2, D>>
         }
      }

      enum Down<D: VMP> {
         typealias Combo = Combos<SComboMRD<M, R, D>>
         typealias R2 = Right2
         typealias D2 = Down2

         enum Right2<R2: VMP> {
            typealias Combo = Combos<SComboMRDR<M, R, D, R2>>
         }

         enum Down2<D2: VMP> {
            typealias Combo = Combos<SComboMRDD<M, R, D, D2>>
         }
      }

      enum LeftDown<LD: VMP> {
         typealias Combo = Combos<SComboMRLD<M, R, LD>>
      }
   }

   enum Down<D: VMP> {
      typealias Combo = Combos<SComboMD<M, D>>
      typealias R = Right
      typealias D2 = Down2

      enum Right<R: VMP> {
         typealias Combo = Combos<SComboMDR<M, D, R>>
         typealias R2 = Right2
         typealias D2 = Down2

         enum Right2<R2: VMP> {
            typealias Combo = Combos<SComboMDRR<M, D, R, R2>>
         }

         enum Down2<D2: VMP> {
            typealias Combo = Combos<SComboMDRD<M, D, R, D2>>
            typealias D3 = Down3

            enum Down3<D3: VMP> {
               typealias Combo = Combos<SComboMDRDD<M, D, R, D2, D3>>
            }
         }
      }

      enum Down2<D2: VMP> {
         typealias Combo = Combos<SComboMDD<M, D, D2>>
         typealias R = Right
         typealias D3 = Down3

         enum Right<R: VMP> {
            typealias Combo = Combos<SComboMDDR<M, D, D2, R>>
         }

         enum Down3<D3: VMP> {
            typealias Combo = Combos<SComboMDDD<M, D, D2, D3>>
         }
      }
   }
}
