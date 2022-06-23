//
//  PaddingLabel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

protocol Marginable {
    var padding: UIEdgeInsets? { get set }
}

final class PaddingLabel: UILabel, Marginable {
    var padding: UIEdgeInsets?

    override public func draw(_ rect: CGRect) {
        if let insets = padding {
            drawText(in: rect.inset(by: insets))
        } else {
            drawText(in: rect)
        }
    }

    override var intrinsicContentSize: CGSize {
        guard let text = text else { return super.intrinsicContentSize }

        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = contentSize.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0

        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            print()
            print(contentSize)
            print(textWidth)
            print(insetsWidth)
            textWidth -= insetsWidth
        }

        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
                                        options: [.usesLineFragmentOrigin],
                                        attributes: [NSAttributedString.Key.font: font!],
                                        context: nil)

        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth

        return contentSize
    }
}


/// Description
final class PaddingTextField: UITextField, Marginable {

    // padding extension
    var padding: UIEdgeInsets?

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? .zero)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? .zero)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? .zero)
    }
}
