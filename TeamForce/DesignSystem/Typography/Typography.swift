//
//  TypographyProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.07.2022.
//

import Foundation

protocol TypographyProtocol {
    associatedtype DesignType

    var `default`: DesignType { get }

    var headline2: DesignType { get }
    var headline3: DesignType { get }
    var headline4: DesignType { get }
    var headline5: DesignType { get }
    var headline6: DesignType { get }

    var title: DesignType { get }
    var body1: DesignType { get }
    var body2: DesignType { get }
    var subtitle: DesignType { get }
    var caption: DesignType { get }
    var counter: DesignType { get }
}
