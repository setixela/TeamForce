//
//  String+DateFormat.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 29.08.2022.
//

import Foundation

extension String {
   private var dateFormat: String { "yyyy-MM-dd'T'HH:mm:ss.SSSZ" }

   var dateConvertedToDate: Date? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = dateFormat
      guard let convertedDate = inputFormatter.date(from: self) else { return nil }
      return convertedDate
   }
   
   var dateConverted: String {
      guard let convertedDate = dateConvertedToDate else { return "" }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "d MMM y"

      return outputFormatter.string(from: convertedDate)
   }

   var timeAgoConverted: String {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = dateFormat
      guard let convertedDate = inputFormatter.date(from: self) else { return "" }

      let formatter = RelativeDateTimeFormatter()
      formatter.unitsStyle = .full
      return formatter.localizedString(for: convertedDate, relativeTo: Date())
   }
}
