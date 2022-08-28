//
//  String+DrawImage.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import UIKit

extension String {
   func drawImage(backColor: UIColor) -> UIImage {
      let text = self
      let attributes = [
         NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
         NSAttributedString.Key.backgroundColor: backColor
      ]
      let textSize = text.size(withAttributes: attributes)

      let renderer = UIGraphicsImageRenderer(size: textSize)
      let image = renderer.image(actions: { _ in
         text.draw(at: CGPoint.zero, withAttributes: attributes)
      })
      return image
   }
}
