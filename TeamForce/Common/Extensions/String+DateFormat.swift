//
//  String+DateFormat.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 29.08.2022.
//

import Foundation

enum DateFormat: String {
   case full = "d MMM y HH:mm"
   case medium = "d MMM y"
   case digits = "dd.MM.yyyy"
}

enum BackEndDateFormat: String, CaseIterable {
   case dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
   case dateFormatFull = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

extension Date {
   func convertToString(_ format: DateFormat = .full) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = format.rawValue
      let result = formatter.string(from: self)
      return result
   }
}

extension String {
   func convertToDate(_ format: DateFormat = .full) -> String? {
      let inputFormatter = DateFormatter()
      return BackEndDateFormat.allCases.compactMap {
         inputFormatter.dateFormat = $0.rawValue
         if let convertedDate = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.dateFormat = format.rawValue

            return outputFormatter.string(from: convertedDate)
         }
         return nil
      }.first
   }
}

extension String {
   var dateConvertedToDate: Date? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = BackEndDateFormat.dateFormatFull.rawValue
      guard let convertedDate = inputFormatter.date(from: self) else { return nil }
      return convertedDate
   }

   var dateConverted: String {
      guard let convertedDate = dateConvertedToDate else { return "" }

      let outputFormatter = DateFormatter()
      outputFormatter.locale = Locale(identifier: "ru_RU")
      outputFormatter.dateFormat = "d MMM y"

      return outputFormatter.string(from: convertedDate)
   }

   var timeAgoConverted: String {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = BackEndDateFormat.dateFormatFull.rawValue
      guard let convertedDate = inputFormatter.date(from: self) else { return "" }

      let formatter = RelativeDateTimeFormatter()
      formatter.locale = Locale(identifier: "ru_RU")
      formatter.unitsStyle = .full
      return formatter.localizedString(for: convertedDate, relativeTo: Date())
   }
   
   var dateFullConverted: String {
      guard let convertedDate = dateConvertedToDate else { return "" }

      let outputFormatter = DateFormatter()
      outputFormatter.locale = Locale(identifier: "ru_RU")
      outputFormatter.dateFormat = "d MMM y HH:mm"

      return outputFormatter.string(from: convertedDate)
   }
}
