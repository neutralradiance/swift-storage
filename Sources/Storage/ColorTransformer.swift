//
//  File.swift
//  
//
//  Created by neutralradiance on 11/28/20.
//

import SwiftUI

@objc(ColorTransformer)
public final class ColorTransformer: NSSecureUnarchiveFromDataTransformer {

    public static let name = NSValueTransformerName(rawValue: String(describing: ColorTransformer.self))

    public override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }

    public static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
