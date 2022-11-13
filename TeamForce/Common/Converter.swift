//
//  Converter.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.11.2022.
//

protocol Converter {
   associatedtype In
   associatedtype Out

   static func convert(_ input: In) -> Out?
}
