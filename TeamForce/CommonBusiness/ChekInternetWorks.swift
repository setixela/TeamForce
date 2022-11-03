//
//  ChekInternetWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.11.2022.
//

import ReactiveWorks

protocol CheckInternetWorks {}

extension CheckInternetWorks {
   var checkInternet: Work<Void, Void> { InetCheckWorker().work }
}
