//
//  Colors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import Foundation
import UIKit

protocol ColorsProtocol: InitProtocol {
    var background: UIColor { get }
    var background1: UIColor { get }
}

struct Colors: ColorsProtocol {
    var background: UIColor { .white }
    var background1: UIColor { .init(white: 0.93, alpha: 1) }
}
