//
//  File.swift
//
//
//  Created by William Luke on 1/27/21.
//

import Foundation

public protocol Identifiable {
	associatedtype ID: Hashable
	var id: ID { get set }
}
