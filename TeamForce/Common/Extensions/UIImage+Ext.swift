//
//  UIImage+Ext.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.11.2022.
//

import UIKit

extension UIImage {

   /// Возвращает сумму яркостей пикселей изображения
   var brightness: CGFloat {
      guard
         let cgImage = cgImage,
         let providerData = cgImage.dataProvider?.data,
         let data = CFDataGetBytePtr(providerData)
      else { return 0 }

      let numberOfComponents = cgImage.bitsPerPixel / 8
      var sum: CGFloat = 0
      var count: CGFloat = 0
      for yPos in 0 ..< cgImage.height {
         for xPos in 0 ..< cgImage.width {
            let pixelData = ((Int(cgImage.width) * yPos) + xPos) * numberOfComponents

            var pixelSum: CGFloat = 0
            for index in 0 ..< numberOfComponents - 1 {
               pixelSum += CGFloat(data[pixelData + index]) / 255.0
            }
            let pixelBright = pixelSum / CGFloat(numberOfComponents - 1)

            count += 1
            sum += pixelBright
         }
      }

      return sum / count
   }

   /// Возвращает выбранную область изображения (cropping)
   func cropped(rect: CGRect) -> UIImage {
      guard
         let cgImage = cgImage,
         let cropped = cgImage.cropping(to: rect)
      else { return self }

      let image = UIImage(cgImage: cropped)
      return image
   }

   func resized(to size: CGSize) -> UIImage {
      guard self.size.width > size.width else { return self }

      return UIGraphicsImageRenderer(size: size).image { _ in
         draw(in: CGRect(origin: .zero, size: size))
      }
   }

   func resized(to width: CGFloat) -> UIImage {
      guard size.width > width else { return self }

      let coef = size.width / size.height
      let newSize = CGSize(width: width, height: width / coef)

      return UIGraphicsImageRenderer(size: newSize).image { _ in
         draw(in: CGRect(origin: .zero, size: newSize))
      }
   }
}
