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
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
         NSAttributedString.Key.backgroundColor: backColor
      ]
      let textSize = text.size(withAttributes: attributes)
      let newSize = CGSize(width: 40, height: 40)

      let renderer = UIGraphicsImageRenderer(size: newSize)
      let image = renderer.image(actions: { _ in
         text.draw(at: CGPoint(x: newSize.width / 2 - textSize.width / 2,
                               y: newSize.height / 2 - textSize.height / 2),
                   withAttributes: attributes)
      })
      return image
   }
}
