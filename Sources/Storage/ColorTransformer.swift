//
//  File.swift
//
//
//  Created by neutralradiance on 11/28/20.
//

import SwiftUI

#if os(macOS)
	typealias NativeColor = NSColor
#elseif os(iOS)
	typealias NativeColor = UIColor
#endif

@objc(ColorTransformer)
public final class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
	public static let name =
		NSValueTransformerName(
			rawValue:
			String(
				describing: ColorTransformer.self
			)
		)
	override public static var allowedTopLevelClasses: [AnyClass] {
		return [NativeColor.self]
	}

	public static func register() {
		let transformer = ColorTransformer()
		ValueTransformer.setValueTransformer(transformer, forName: name)
	}
}
